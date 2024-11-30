//
//  CompactMonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

/// A view that used when screen is compact that will show days with duty colors.
struct CompactMonthView: View {

    /// Stores the use preference of the first day of week to User Default.
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday

    /// Stores the use preference of on if Bank Holidays duties change to User Default.
    @AppStorage("bankHolidayRule") var bankHolidayRule = true
    
    /// A property for a `DutyDetail`
    var dayDuty: DutyDetail
    
    /// A property for the date that user select.
    @Binding var selectedDate: Date

    /// An array of iCalendar events for the month.
    @Binding var monthEvents: [EKEvent]

    /// An array of iCalendar events for on `selectedDate`.
    @Binding var events: [EKEvent]

    /// An instance passed to view of `EKEventStore`.
    var eventStore: EKEventStore

    /// An array of Ad Hoc Duties for the month.
    var adHocDuties: [AdHocDuty]

    /// An array of the Bank holidays.
    var bankHolidays: [BankHolidayEvent]

    /// An array of calculated `DutyDetails`
    var dutyDetails: [DutyDetail]

    /// Passed in method to ask permission and get iCalendar Events.
    ///
    /// - Important: If access not granted, iCalendar events will not show in Calendar.
    var loadEvent: () -> Void
    
    /// Passed in method to reset the `controlDate` to `.distantPast`
    var resetControlDate: () -> Void
    
    /// A computed array that calculates the date in a month including days before the 1st of week.
    ///
    /// Returns a `CalendarDate` array of all the dates in the month.
    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }
    
    /// A computed property that calculates the first day of month array.
    ///
    /// This may not be the first date of month. It will be whatever the first day of week that the month start in.
    var calendarFirstDate: Date {
        guard let calendarFirst = calendarDates.first else { fatalError("No first date") }
        return calendarFirst.date
    }
    
    /// A computed array of Ad Hoc duties that fall on `selectedDate` and `overtime` is also `true`.
    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isSameDay(as: selectedDate) && $0.overtime }
    }
    
    /// A computed property that if all iCalendar Event, Ad Hoc Duties and Duties then will sure `true`.
    var listsAreNotEmpty: Bool {
        events.isNotEmpty || filteredDuties.isNotEmpty || dayDuty.title.isNotEmpty
    }

    var body: some View {
        Group {
            HStack {
                ForEach(WeekDay.sortedWeekDays(startOn: startDayOfWeek), id: \.self) {
                    Text($0)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<calendarDates.count, id: \.self) { day in
                    MonthRowView(monthEvents: monthEvents,
                                 adHocDuties: adHocDuties,
                                 dutyDetails: dutyDetails,
                                 day: calendarDates[day],
                                 startDateOfCalendar: calendarDates.first!.date,
                                 selectedDate: $selectedDate,
                                 bankHolidays: bankHolidays
                    )
                }
            }
            .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            if listsAreNotEmpty {
                List {
                    if dayDuty.title.isNotEmpty {
                        DutyDetailRowView(dutyDetail: dayDuty, adHocDuties: adHocDuties, resetControlDate: resetControlDate)
                            .listRowBackground(Color(dayDuty.color))
                    }

                    if filteredDuties.isNotEmpty {
                        AdHocDutyView(filteredDuties: filteredDuties)
                            .listRowBackground(Color.dutyAdHoc)
                    }

                    if events.isNotEmpty {
                        EventView(events: $events, eventStore: eventStore, loadEvent: loadEvent)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            } else {
                ContentUnavailableView("No Events", systemImage: "calendar")
            }
        }
    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
