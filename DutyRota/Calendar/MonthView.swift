//
//  MonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct MonthView: View {
    var rotaLines: [String]

    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday

    @Query var rota: [Rota]

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var adHocDuties: [AdHocDuty]
    var bankHolidays: [BankHolidayEvent]
    var dutyDetails: [DutyDetail]

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var calendarFirstDate: Date {
        guard let calendarFirst = calendarDates.first else {
            fatalError("No first date")
        }

        return calendarFirst.date
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
                                 rotas: rotaLines,
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
        }
    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
