//
//  MonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 03/03/2024.
//

import EventKit
import EventKitUI
import SwiftData
import SwiftUI

///  A view that used when screen is regular that will show days with duty colors.
struct RegularMonthView: View {

    /// Stores the use preference of the first day of week to User Default.
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday

    /// Stores the use preference of on if Bank Holidays duties change to User Default.
    @AppStorage("bankHolidayRule") var bankHolidayRule = true
    
    /// A passed in `Binding` property for the date that user select.
    @Binding var selectedDate: Date

    /// A passed in array that hold duty details for the month.
    var dutyDetails: [DutyDetail]

    /// A passed in array of the Bank holidays.
    var bankHolidays: [BankHolidayEvent]

    /// An array of iCalendar events for on `selectedDate`.
    @Binding var monthEvents: [EKEvent]
    
    /// An instance passed to view of `EKEventStore`.
    var eventStore: EKEventStore

    /// Passed in method to ask permission and get iCalendar Events.
    ///
    /// - Important: If access not granted, iCalendar events will not show in Calendar.
    var loadEvent: () -> Void
    
    /// Passed in method to reset the `controlDate` to `.distantPast`.
    var resetControlDate: () -> Void
    
    /// A property that a selected event to trigger a `EventDetailView(event: )`.
    @State private var event: EKEvent?

    /// A property that a selected event to trigger a `EditAdHocDutyView(adHocDuty: , isEditing: )`.
    @State private var selectedDuty: AdHocDuty?

    @Query var adHocDuties: [AdHocDuty]
    @Query var holidays: [Holiday]
    
    /// A computed array of dates from vacation period.
    var holidayDates: [Date] {
        var newHolidayDates = [Date]()
        for holiday in holidays {
            var newDate = holiday.start.startOfDay
            while newDate <= holiday.end {
                newHolidayDates.append(newDate)
                newDate = newDate.add(day: 1)
            }
        }
        return newHolidayDates
    }
    
    /// A computed array of `CalendarDate` of the current month.
    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }
    
    /// A computed array of `AdHocDuty` of the current month.
    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) }
    }

    var body: some View {
        VStack(spacing: 2) {
            HStack {
                // MARK: - Days of week.
                ForEach(WeekDay.sortedWeekDays(startOn: startDayOfWeek, full: true), id: \.self) {
                    Text($0)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 17))
                }
            }

            Divider()
                .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(0..<calendarDates.count, id: \.self) { dayIndex in
                        let dayEvents = monthEvents.filter { $0.startDate.isSameDay(as: calendarDates[dayIndex].date)}
                        VStack(spacing: 2) {
                            // MARK: - Dates of month.
                            if calendarDates[dayIndex].date >= selectedDate.startDateOfMonth {
                                Button {
                                    selectedDate = calendarDates[dayIndex].date
                                } label: {
                                    VStack {
                                        Text(calendarDates[dayIndex].date, format: .dateTime.day())
                                            .selected(date: selectedDate, sameAs: calendarDates[dayIndex].date, bgColor: "dutyClear")
                                            .bold()
                                    }
                                }
                                .padding(.vertical, 5)
                                .buttonStyle(.plain)
                                // MARK: - DUTIES (inc Ad Hoc duties that are not overtime)
                                if dutyDetails.isNotEmpty {
                                    if dayIndex < dutyDetails.count {
                                        DayDutiesRowView(dutyDetail: dutyDetails[dayIndex], resetControlDate: resetControlDate)
                                    }
                                }
                                // MARK: - AD HOC DUTIES (If overtime)
                                if (filteredDuties.contains { $0.start.isSameDay(as: calendarDates[dayIndex].date) && $0.overtime }) {
                                    let dayAdHocDuties = filteredDuties.filter { $0.start.isSameDay(as: calendarDates[dayIndex].date) }
                                    ForEach(dayAdHocDuties) { duty in
                                        DayAdHocDutiesRowView(duty: duty) {
                                            selectedDuty = duty
                                        }
                                    }
                                }
                                // MARK: - iCAL EVENTS
                                if dayEvents.isNotEmpty {
                                    ForEach(dayEvents) { dayEvent in
//                                        if dayEvent.calendar.type == .calDAV || dayEvent.calendar.type == .local {
                                        if dayEvent.calendar.isImmutable == false {
                                            Button {
                                                event = dayEvent
                                            } label: {
                                                DayEventView(event: dayEvent)
                                            }
                                            .buttonStyle(.plain)
                                            .hoverEffect()
                                        } else {
                                            DayEventView(event: dayEvent)
                                        }
                                    }
                                }
                            } else {
                                // MARK: - ALL LISTS ARE EMPTY
                                Text("")
                                    .frame(maxWidth: .infinity)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 6)
                        .containerRelativeFrame(.vertical) { height, axis in
                            height / 5
                        }
                        .background {
                            Group {
                                if bankHolidays.contains(where: { $0.date == calendarDates[dayIndex].date }) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.yellow, lineWidth: 3)
                                } else if holidayDates.contains(where: { $0 == calendarDates[dayIndex].date }) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.red, lineWidth: 3)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.clear, lineWidth: 3)
                                }
                            }
                        }
                    }
                }

            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .sheet(item: $selectedDuty) { duty in
            EditAdHocDutyView(adHocDuty: duty, isEditing: true)
        }
        .sheet(item: $event) { event in
            EventDetailView(event: event)
//            EventEditViewController(event: event, eventStore: eventStore, loadEvent: loadEvent)
        }
        .onAppear { selectedDate = .now }
    }
}

//#Preview {
//    NavigationStack {
//        MonthView(selectedDate: .constant(.now), dutyForMonth: [], dutyDetails: [], bankHolidays: [], monthEvents: .constant([]))
//            .navigationTitle("Today")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
