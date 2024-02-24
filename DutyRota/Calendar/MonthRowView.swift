//
//  MonthRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 02/02/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct MonthRowView: View {
    var monthEvents: [EKEvent]
    var adHocDuties: [AdHocDuty]
    var rotas: [String]
    var day: CalendarDate
    var startDateOfCalendar: Date

    @Binding var selectedDate: Date

    var bankHolidays: [BankHolidayEvent]

    @Query var duties: [Duty]
    @Query var holidays: [Holiday]

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

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) }
    }

    var dayIndex: Int {
        day.date.startOfDay.dayDifference(from: startDateOfCalendar)
    }

    var dutyDetails: [DutyDetail] {
        if let currentDuty = duties.first(where: { startDateOfCalendar.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
            if currentDuty.periodEnd >= day.date {
                return currentDuty.dutyDetails
            }
            if let newDuty = duties.first(where: { day.date.isDateInRange(start: $0.periodStart.add(day: -1), end: $0.periodEnd) }) {
                return newDuty.dutyDetails
            }
        } else if let currentDuty = duties.first(where: { $0.periodStart.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) }) {
            return currentDuty.dutyDetails
        }
        return []
    }

    var body: some View {
        VStack(spacing: 0) {
            if day.date >= selectedDate.startDateOfMonth {
                Button {
                    selectedDate = day.date
                } label: {
                    VStack {
                        Text(day.date, format: .dateTime.day())
                            .selected(date: selectedDate, sameAs: day.date)
                            .bold()
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 42, height: 42)
            }

            HStack(spacing: 4) {
                if (monthEvents.contains { $0.startDate.sameDay(as: day.date) }) {
                    Circle()
                        .frame(width: 5)
                }

                if (filteredDuties.contains { $0.start.sameDay(as: day.date) }) {
                    Circle()
                        .fill(.orange)
                        .frame(width: 5)
                } else if (!monthEvents.contains { $0.startDate.sameDay(as: day.date) }) {
                    Circle()
                        .fill(.clear)
                        .frame(width: 5)
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .background {
            DutyBackground(
                for: color(dayIndex),
                isDay: day.date >= selectedDate.startDateOfMonth,
                isBankHoliday: bankHolidays.contains(where: { $0.date == day.date }),
                isHoliday: holidayDates.contains(where: { $0 == day.date } )
            )
        }
    }

    func color(_ dayIndex: Int) -> String {
        guard rotas.isNotEmpty, dutyDetails.isNotEmpty else { return "dutyClear" }

        if let dutyDetail = (dutyDetails.first { $0.title == rotas[dayIndex] }) {
            return dutyDetail.color
        } else {
            return "dutyError"
        }
    }
}

//#Preview {
//    MonthRowView(monthEvents: <#[EKEvent]#>, adHocDuties: AdHocDuty.sampleAdHocDuties, day: CalendarDate(date: .now), selectedDate: .constant(.now))
//}


