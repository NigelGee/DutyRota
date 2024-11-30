//
//  CalendarView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

/// A view that show a date calendar and work duties details and iCalendar events.
struct CalendarView: View {

    /// Stores the use preference of the first day of week to User Default.
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday

    /// Stores the use preference of on if Bank Holidays duties change to User Default.
    @AppStorage("bankHolidayRule") var bankHolidayRule = true
    
    /// Keep track of which "Tab" the user is on.
    @AppStorage("selectedTab") var selectedTab: Tabs = .calendar

    /// Stores the use preference of on how much time should pass before deleting old Ad Hoc Duties to User Default.
    @AppStorage("purgeTime") var purgePeriod: PurgePeriod = .sixMonth

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var sizeClass

    /// A property to show the a sheet to add Ad Hoc Duties.
    @State private var showAddAdHocDuty = false

    /// A property to show the a sheet to add New Calendar Event.
    @State private var showAddEvent = false
    
    /// A property for the date that user select.
    @State private var selectedDate = Date.now

    /// A property that prevent `getRotaDuties()` running when in the same month as previous `selectDate`.
    @State private var controlDate = Date.distantPast

    @State private var eventStore = EKEventStore()

    /// An array that hold Calendar Events for the `selectedDate`.
    @State private var events = [EKEvent]()

    /// An array that hold Calendar Events for the select month.
    @State private var monthEvents = [EKEvent]()

    /// A property to add a new ad hoc duty.
    @State private var newDuty: AdHocDuty?

    /// A property to if no duty can be found.
    @State private var dayDuty = DutyDetail.loading
    
    /// An array that hold duty details for the month.
    @State private var dutyDetails = [DutyDetail]()
    
    /// An array that hold Bank Holiday dates that maybe in the month.
    @State private var bankHolidays = [BankHolidayEvent]()

    /// A property that show `true` if unable to get the bank holidays from [gov.co.uk](https://www.gov.uk/bank-holidays.json)
    @State private var showErrorBH = false
    
    /// A property that show `true` if the month is December or January to display warning text.
    @State private var christmasNewYear = false

    @Query(sort: \AdHocDuty.start) var adHocDuties: [AdHocDuty]
    @Query var duties: [Duty]
    @Query var rota: [Rota]

    /// A computed array that calculates the date in a month including days before the 1st of week.
    ///
    /// Returns a `CalendarDate` array of all the dates in the month.
    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0.startOfDay) }
    }

    /// A computed property that calculates the number index of selected date.
    ///
    /// Returns: An `Int` from the start of month to `selectedDate`.
    var selectedDayIndex: Int {
        selectedDate.dayDifference(from: calendarDates.first!.date)
    }
    
    /// A view that show a message if December or January
    var christmasMessage: some View {
        HStack(spacing: 5) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.black, .yellow)
                .symbolVariant(.fill)

            Text("Duties may change over Christmas and New Year")
                .font(.caption)
        }
        .isPresented(for: christmasNewYear)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VortexEffectView()
                
                VStack {
                    christmasMessage

                    if sizeClass == .compact {
                        CompactMonthView(
                            dayDuty: dayDuty,
                            selectedDate: $selectedDate,
                            monthEvents: $monthEvents,
                            events: $events,
                            eventStore: eventStore,
                            adHocDuties: adHocDuties,
                            bankHolidays: bankHolidays,
                            dutyDetails: dutyDetails,
                            loadEvent: loadEvent,
                            resetControlDate: resetControlDate
                        )
                    } else {
                        RegularMonthView(
                            selectedDate: $selectedDate,
                            dutyDetails: dutyDetails,
                            bankHolidays: bankHolidays,
                            monthEvents: $monthEvents,
                            eventStore: eventStore,
                            loadEvent: loadEvent,
                            resetControlDate: resetControlDate
                        )
                        .padding(.horizontal, 5)
                    }
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                loadEvent()
                await fetchBankHolidays()
                await getRotaDuties()
                await getDayDuty(dutyDetails: dutyDetails)
                await purgeAdHocDuties(for: purgePeriod)
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    refreshCalendar()
                }
            }
            .onChange(of: selectedDate) { refreshCalendar() }
            .onChange(of: controlDate) { refreshCalendar() }
            .onChange(of: selectedTab) {
                resetControlDate()
                refreshCalendar()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu("Add New Event", systemImage: "calendar.badge.plus") {
                        Button {
                            addNewDuty()
                        } label: {
                            Label("New Duty", systemImage: "book.pages")
                        }

                        Button {
                            showAddEvent = true
                        } label: {
                            Label("New Event", systemImage: "calendar")
                        }
                    }
                }

                ToolbarItem(placement: .principal) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        selectedDate = .now
                    }
                }
            }
            .sheet(isPresented: $showAddAdHocDuty, onDismiss: onDismiss) {
                if let newDuty {
                    EditAdHocDutyView(adHocDuty: newDuty, isEditing: false)
                }
            }
            .sheet(isPresented: $showAddEvent, onDismiss: loadEvent) {
                AddNewEventView(eventStore: eventStore, selectedDate: selectedDate, loadEvent: loadEvent)
            }
            .alert("No Internet", isPresented: $showErrorBH) {
                Button("OK") { }
            } message: {
                Text("Bank Holidays duties might not show correctly in calendar.")
            }
        }
    }

    /// A method to get JSON bank holidays from [gov.co.uk](https://www.gov.uk/bank-holidays.json).
    ///
    /// If unable to decode or no network will show an alert to user that unable to get Bank Holidays dates.
    func fetchBankHolidays() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        do  {
            async let items = try await URLSession.shared.decode(BankHoliday.self, from: "https://www.gov.uk/bank-holidays.json", dateDecodingStrategy: .formatted(dateFormatter))
            bankHolidays = try await items.englandAndWales.events
        } catch {
            showErrorBH = true
            print("Failed to fetch Bank Holiday data!")
        }
    }
    
    /// Passed in method to ask permission and get iCalendar Events.
    ///
    /// - Important: If access not granted, iCalendar events will not show in Calendar.
    func loadEvent() {
        let calendar = Calendar.current
        guard calendar.identifier == .gregorian else { return }
        eventStore.requestFullAccessToEvents { granted, error in
            if granted && error == nil {
                let startDay = selectedDate.startOfDay

                let predicateDay = eventStore.predicateForEvents(withStart: startDay, end: selectedDate.endOfDay, calendars: nil)

                let predicateMonth = eventStore.predicateForEvents(withStart: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth, calendars: nil)

                events = eventStore.events(matching: predicateDay)

                monthEvents = eventStore.events(matching: predicateMonth)

            } else {
                print("Error in loading Events")
            }
        }
    }
    
    /// A method to a new Ad Hoc Duty to calendar.
    ///
    /// This will add a default record to SwiftData and open `AddDutyDetailView`
    func addNewDuty() {
        var defaultBreakTime: Date {
            var components = DateComponents()
            components.hour = 1
            components.minute = 0
            return Calendar.current.date(from: components) ?? Date.now
        }

        let newDuty = AdHocDuty(title: "", route: "", start: selectedDate, end: selectedDate.addingTimeInterval(30_960), breakTime: defaultBreakTime)
        modelContext.insert(newDuty)

        self.newDuty = newDuty

        showAddAdHocDuty = true
    }
    
    /// A method to check that the new Ad Hoc Duty has a title.
    ///
    /// If no title will delete the record from SwiftData.
    func onDismiss() {
        if let newDuty {
            if newDuty.title.isEmpty {
                let object = newDuty
                modelContext.delete(object)
            }
        }
        resetControlDate()
    }
    
    /// A method to get current month duties.
    ///
    /// An array of `DutyDetails` taken it account of Bank Holidays and Ad Hoc Duties.
    /// - Precondition: If user select date in same month then will not run.
    /// - Complexity: O(1)
    func getRotaDuties() async {
        guard !selectedDate.isSameMonth(as: controlDate) else { return }
        controlDate = selectedDate
        var newRotaDuties = [String]()
        var newDuties = [DutyDetail]()
        guard let startOfCalendarMonth = calendarDates.first?.date.startOfDay else { return }
        guard let endOfCalendarMonth = calendarDates.last?.date.startOfDay else { return }

        for week in 0..<8 {
            let weekStartDate = startOfCalendarMonth.add(day: week * 7)
            guard weekStartDate < endOfCalendarMonth else { break }

            // ROTA
            guard let currentRota = rota.first(where: { weekStartDate.isDateInRange(start: $0.periodStart, end: $0.periodEnd) || weekStartDate.isSameDay(as: $0.periodStart) }) else {
                newRotaDuties.append(contentsOf: RotaDetail.emptyWeek)
                newDuties.append(contentsOf: DutyDetail.emptyWeek)
                continue
            }
            let startRotaLine = currentRota.startRotaLine == 0 ? currentRota.unwrappedRotaDetails.map { $0.line }.min() ?? 0 : currentRota.startRotaLine
            let weeksFromStartRotaLine = Int((weekStartDate.dayDifference(from: currentRota.periodStart.startOfDay)) / 7)
            let minLineNumber = currentRota.unwrappedRotaDetails.map { $0.line }.min() ?? 0

            let currentWeekLine = ((startRotaLine + weeksFromStartRotaLine - minLineNumber) % currentRota.unwrappedRotaDetails.count) + minLineNumber
            guard let rotaLineDetails = currentRota.unwrappedRotaDetails.first(where:  { $0.line == currentWeekLine }) else {
                newRotaDuties.append(contentsOf: RotaDetail.emptyWeek)
                continue
            }
            let weekRotaLines = RotaDetail.weekDuties(of: rotaLineDetails, for: startDayOfWeek)
            newRotaDuties.append(contentsOf: weekRotaLines)

            // DUTIES
            guard let currentDuty = duties.first(where: { weekStartDate.isDateInRange(start: $0.periodStart, end: $0.periodEnd) || weekStartDate.isSameDay(as: $0.periodStart) }) else { continue }

            for line in weekRotaLines {
                guard let duty = currentDuty.unwrappedDutyDetails.first(where: { $0.title == line }) else {
                    newDuties.append(DutyDetail.dutyError(for: line))
                    continue
                }
                newDuties.append(duty)
            }
        }

        var bankHolidaysInMonth = [Date]()
        for holiday in bankHolidays {
            if holiday.date.isDateInRange(start: startOfCalendarMonth, end: endOfCalendarMonth) {
                bankHolidaysInMonth.append(holiday.date)
            }
        }

        christmasNewYear = christmasNewYear(from: bankHolidaysInMonth)

        // BANK HOLIDAYS
        if bankHolidayRule, bankHolidaysInMonth.isNotEmpty, !christmasNewYear {
            for holiday in bankHolidaysInMonth {
                let holidayIndex = holiday.dayDifference(from: startOfCalendarMonth)
                if newDuties[holidayIndex].title.isNotEmpty, newDuties[holidayIndex].title != "Rest" {
                    // Bank holiday Monday check
                    if holiday.isBankHoliday(.monday) {
                        // Check if not the first day of month data
                        if holidayIndex - 1 > 0 {
                            // Check if the Sunday is a rest day
                            if newDuties[holidayIndex - 1].title.isEmpty || newDuties[holidayIndex - 1].title == "Rest" {
                                newDuties.replaceElement(at: holidayIndex, with: DutyDetail.spare)
                            } else {
                                newDuties.replaceElement(before: holidayIndex)
                            }
                        } else {
                            newDuties.replaceElement(at: holidayIndex, with: DutyDetail.dutyError(for: "Check"))
                        }
                    } else if holiday.isBankHoliday(.friday) {
                        // Check if not the last day of month data
                        if holidayIndex + 1 < newDuties.count {
                            // Check if the Saturday is a rest day
                            if newDuties[holidayIndex + 1].title.isEmpty || newDuties[holidayIndex + 1].title == "Rest" {
                                newDuties.replaceElement(at: holidayIndex, with: DutyDetail.spare)
                            } else {
                                newDuties.replaceElement(after: holidayIndex)
                            }
                        } else {
                            newDuties.replaceElement(at: holidayIndex, with: DutyDetail.dutyError(for: "Check"))
                        }
                    }
                }
            }
        }

        // AD HOC DUTIES
        if adHocDuties.isNotEmpty {
            let duties = adHocDuties.filter({ $0.start >= startOfCalendarMonth && $0.end <= endOfCalendarMonth && $0.overtime == false })
            for duty in duties {
                let dutyIndex = duty.start.dayDifference(from: startOfCalendarMonth)
                if dutyIndex >= 0 && dutyIndex < newDuties.count {
                    let replacedDuty = DutyDetail(id: duty.id, title: duty.title, start: duty.start, end: duty.end, tod: duty.todDate, color: "dutyAdHoc", notes: duty.notes, route: duty.route, isAdHoc: true)
                    newDuties.replaceElement(at: dutyIndex, with: replacedDuty)
                }
            }
        }

        dutyDetails = newDuties
    }
    
    /// A method to calculate if month is Christmas or New Year.
    /// - Parameter dates: an array of Bank Holidays in the month.
    /// - Returns: `true` if Bank Holidays contians Christmas or New Year.
    func christmasNewYear(from dates: [Date]) -> Bool {
        guard dates.isNotEmpty else { return false }
        guard bankHolidayRule else { return false }

        for date in dates {
            let dateComponents = Calendar.current.dateComponents([.day, .month], from: date)
            return dateComponents.day == 25 && dateComponents.month == 12 || dateComponents.day == 1 && dateComponents.month == 1
        }
        return false
    }
    
    /// A method to find to duty on a `selectedDate`
    /// - Parameter dutyDetails: an array of `DutyDetail` for the month.
    ///- Precondition: If the day index is less then total Duty Details array else bail out.
    func getDayDuty(dutyDetails: [DutyDetail]) async {
        guard selectedDayIndex < dutyDetails.count else { return }
        let duty = dutyDetails[selectedDayIndex]
        dayDuty = duty
    }
    
    /// A method to reset the `controlDate` to `.distantPast`
    func resetControlDate() {
        controlDate = .distantPast
    }
    
    /// A method to refresh Calendar data.
    ///
    /// This will be called when the user move from the calendar to other tabs or the app goes from background to active scene phase.
    func refreshCalendar() {
        loadEvent()
        Task {
            await getRotaDuties()
            await getDayDuty(dutyDetails: dutyDetails)
        }
    }
    
    /// A method to delete old ad hoc duties for SwiftData.
    /// - Parameter period: A period from user from a `.year, .sixMonth, .month, .never`
    func purgeAdHocDuties(for period: PurgePeriod) async {
        guard period != .never && adHocDuties.isNotEmpty else { return }

        let purgeDate: Date

        switch period {
        case .year:
            purgeDate = Date.now.addingTimeInterval(-365 * 24 * 60 * 60)
        case .sixMonth:
            purgeDate = Date.now.addingTimeInterval(-183 * 24 * 60 * 60)
        case .month:
            purgeDate = Date.now.addingTimeInterval(-31 * 24 * 60 * 60)
        case .never:
            purgeDate = .distantPast
        }

        for duty in adHocDuties {
            if duty.start < purgeDate {
                modelContext.delete(duty)
            }
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(AdHocDuty.self)
//    return CalendarView()
//        .modelContainer(preview.container)
//}
