//
//  CalendarView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct CalendarView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @AppStorage("bankHolidayRule") var bankHolidayRule = true
    @AppStorage("selectedTab") var selectedTab: Tabs = .calendar

    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var sizeClass

    @State private var showDialog = false
    @State private var showAddAdHocDuty = false
    @State private var showAddEvent = false

    @State private var selectedDate = Date.now
    @State private var controlDate = Date.distantPast

    @State private var eventStore = EKEventStore()
    @State private var events = [EKEvent]()
    @State private var monthEvents = [EKEvent]()
    @State private var newDuty: AdHocDuty?
    @State private var dutyDetails = [DutyDetail]()
    @State private var dayDuty = DutyDetail.loading

    @State private var bankHolidays = [BankHolidayEvent]()
    @State private var showErrorBH = false

    @Query(sort: \AdHocDuty.start) var adHocDuties: [AdHocDuty]
    @Query var duties: [Duty]
    @Query var rota: [Rota]

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0.startOfDay) }
    }

    var selectedDayIndex: Int {
        selectedDate.dayDifference(from: calendarDates.first!.date)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if sizeClass == .compact {
                    CompactMonthView(
                        dayDuty: dayDuty,
                        selectedDate: $selectedDate,
                        monthEvents: $monthEvents,
                        adHocDuties: adHocDuties,
                        bankHolidays: bankHolidays,
                        dutyDetails: dutyDetails,
                        events: $events,
                        eventStore: eventStore,
                        loadEvent: loadEvent
                    )
                } else {
                    RegularMonthView(
                        selectedDate: $selectedDate,
                        dutyDetails: dutyDetails,
                        bankHolidays: bankHolidays,
                        monthEvents: $monthEvents,
                        eventStore: eventStore,
                        loadEvent: loadEvent
                    )
                    .padding(.horizontal, 5)
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadEvent)
            .onChange(of: selectedDate) {
                loadEvent()
                Task {
                    await getRotaDuties()
                    await getDayDuty(dutyDetails: dutyDetails)
                }
            }
            .onChange(of: selectedTab) {
                controlDate = .distantPast
                Task {
                    await getRotaDuties()
                    await getDayDuty(dutyDetails: dutyDetails)
                }
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
            .task {
                await fetchBankHolidays()
                await getRotaDuties()
                await getDayDuty(dutyDetails: dutyDetails)
            }
            .alert("No Internet", isPresented: $showErrorBH) {
                Button("OK") { }
            } message: {
                Text("Bank Holidays duties might not show correctly in calendar.")
            }
        }
    }

    /// Call for get JSON data from URL
    /// requires `@State private var name = [Decodable]()`
    /// and `.task { await fetch() }`
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

    func loadEvent() {
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

    func onDismiss() {
        if let newDuty {
            if newDuty.title.isEmpty {
                let object = newDuty
                modelContext.delete(object)
            }
        }
    }

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

        // BANK HOLIDAYS
        if bankHolidayRule, bankHolidaysInMonth.isNotEmpty {
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
                    } else {
                        // Christmas Week!
                        print("CHRISTMAS BANK HOLIDAYS")
                    }
                }
            }
        }

        dutyDetails = newDuties
    }

    func getDayDuty(dutyDetails: [DutyDetail]) async {
        guard selectedDayIndex < dutyDetails.count else { return }
        let duty = dutyDetails[selectedDayIndex]
        dayDuty = duty
    }
}

//#Preview {
//    let preview = PreviewContainer(AdHocDuty.self)
//    return CalendarView()
//        .modelContainer(preview.container)
//}
