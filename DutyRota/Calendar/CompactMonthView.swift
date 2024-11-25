//
//  CompactMonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct CompactMonthView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @AppStorage("bankHolidayRule") var bankHolidayRule = true

    var dayDuty: DutyDetail

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var adHocDuties: [AdHocDuty]
    var bankHolidays: [BankHolidayEvent]
    var dutyDetails: [DutyDetail]
    @Binding var events: [EKEvent]
    var eventStore: EKEventStore
    var loadEvent: () -> Void
    var resetControlDate: () -> Void

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var calendarFirstDate: Date {
        guard let calendarFirst = calendarDates.first else {
            fatalError("No first date")
        }

        return calendarFirst.date
    }

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isSameDay(as: selectedDate) && $0.overtime }
    }

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
