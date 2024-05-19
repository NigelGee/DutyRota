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
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.horizontalSizeClass) var sizeClass

    @State private var showDialog = false
    @State private var showAddAdHocDuty = false
    @State private var showAddEvent = false

    @State private var selectedDate = Date.now
    @State private var eventStore = EKEventStore()
    @State private var events = [EKEvent]()
    @State private var monthEvents = [EKEvent]()
    @State private var newDuty: AdHocDuty?
    @State private var dutiesForMonth = [String]()

    @State private var bankHolidays = [BankHolidayEvent]()
    @State private var showErrorBH = false

    @Query(sort: \AdHocDuty.start) var adHocDuties: [AdHocDuty]
    @Query var duties: [Duty]
    @Query var rota: [Rota]

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var dutyDetails: [DutyDetail] {
        for day in calendarDates {
            if let currentDuty = duties.first(where: { calendarDates.first!.date.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
                if currentDuty.periodEnd >= day.date {
                    return currentDuty.unwrappedDutyDetails
                }
                if let newDuty = duties.first(where: { day.date.isDateInRange(start: $0.periodStart.add(day: -1), end: $0.periodEnd) }) {
                    return newDuty.unwrappedDutyDetails
                }
            } else if let currentDuty = duties.first(where: { $0.periodStart.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) }) {
                return currentDuty.unwrappedDutyDetails
            }
        }
        return []
    }

    var body: some View {
        NavigationStack {
            VStack {
                if sizeClass == .compact {
                    CompactMonthView(
                        rotaLines: dutiesForMonth,
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
                    MonthView(
                        selectedDate: $selectedDate,
                        dutyForMonth: dutiesForMonth,
                        dutyDetails: dutyDetails,
                        bankHolidays: bankHolidays,
                        monthEvents: $monthEvents,
                        eventStore: eventStore,
                        loadEvent: loadEvent
                    )
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadEvent)
            .onChange(of: selectedDate) {
                loadEvent()
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
            .sheet(isPresented: $showAddEvent) {
                AddNewEventView(eventStore: eventStore, selectedDate: selectedDate, loadEvent: loadEvent)
            }
            .task {
                await fetch()
                monthRotasDuties()
            }
            .onChange(of: selectedDate) {
                monthRotasDuties()
            }
            .alert("No Internet", isPresented: $showErrorBH) {
                Button("OK") { }
            } message: {
                Text("Bank Holidays might not show correctly in calendar.")
            }
        }
    }

    /// Call for get JSON data from URL
    /// requires `@State private var name = [Decodable]()`
    /// and `.task { await fetch() }`
    func fetch() async {
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

    func monthRotasDuties() {
        var monthDuties = [String]()
        var count = 0
        guard let calendarFirst = calendarDates.first else { return }
        guard let calendarLast = calendarDates.last else { return }
        if let currentRota = rota.first(where: { calendarFirst.date.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
            let weeksToStartDate = Int((calendarFirst.date.dayDifference(from: currentRota.periodStart)) / 7) + 1
            var currentLine = currentRota.startRotaLine + weeksToStartDate
            let maxLineNumber = currentRota.unwrappedRotaDetails.map { $0.line }.max() ?? 0
            let minLineNumber = currentRota.unwrappedRotaDetails.map { $0.line }.min() ?? 0

            var remainder = 0
            if currentRota.unwrappedRotaDetails.count > 0 {
                remainder = (currentLine - minLineNumber) % currentRota.unwrappedRotaDetails.count
            }
            currentLine = minLineNumber + remainder

            var end = calendarFirst.date

            for i in 0 ..< 6 {
                if end <= currentRota.periodEnd {
                    count = i
                    guard let rotaDetail = currentRota.unwrappedRotaDetails.first(where: { $0.line == currentLine }) else { continue }
                    monthDuties.append(contentsOf: RotaDetail.weekDuties(of: rotaDetail, for: startDayOfWeek))
                    if currentLine == maxLineNumber {
                        currentLine = minLineNumber
                    } else {
                        currentLine += 1
                    }
                    end = end.add(day: 7)

                } else {
                    end = end.add(day: 7)
                    if let nextRota = rota.first(where: { end.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
                        currentLine = nextRota.startRotaLine - (count + 1) + i
                        guard let nextRotaDetail = nextRota.unwrappedRotaDetails.first(where: { $0.line == currentLine} ) else { continue }
                        monthDuties.append(contentsOf: RotaDetail.weekDuties(of: nextRotaDetail, for: startDayOfWeek))
                    } else {
                        monthDuties.append(contentsOf: RotaDetail.emptyWeek)
                    }
                }
            }
        } else if let currentRota = rota.first(where: { $0.periodStart.isDateInRange(start: calendarFirst.date, end: calendarLast.date) }) {
            let numberOfWeeks = currentRota.periodStart.dayDifference(from: calendarFirst.date) / 7
            for i in 0 ..< 6 {
                if numberOfWeeks > i {
                    monthDuties.append(contentsOf: RotaDetail.emptyWeek)
                } else {
                    let currentLine = currentRota.startRotaLine
                    guard let rotaDetail = currentRota.unwrappedRotaDetails.first(where: { $0.line == (currentLine + count) }) else { continue }
                    monthDuties.append(contentsOf: RotaDetail.weekDuties(of: rotaDetail, for: startDayOfWeek))
                    count += 1
                }
            }
        } 

        dutiesForMonth = monthDuties
    }
}

//#Preview {
//    let preview = PreviewContainer(AdHocDuty.self)
//    return CalendarView()
//        .modelContainer(preview.container)
//}
