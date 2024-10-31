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
    var dutyDetails: [DutyDetail]
    var day: CalendarDate
    var startDateOfCalendar: Date

    @Binding var selectedDate: Date

    var bankHolidays: [BankHolidayEvent]

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

    var body: some View {
        VStack(spacing: 0) {
            if day.date >= selectedDate.startDateOfMonth {
                Button {
                    selectedDate = day.date
                } label: {
                    VStack {
                        Text(day.date, format: .dateTime.day())
                            .selected(date: selectedDate, sameAs: day.date, bgColor: color(dayIndex))
                            .bold()
                    }
                }
                .buttonStyle(.plain)
                .frame(width: 42, height: 42)
            }

            HStack(spacing: 4) {
                if (monthEvents.contains { $0.startDate.isSameDay(as: day.date) }) {
                    Circle()
                        .textTint(bgColorOf: Color(color(dayIndex)))
                        .frame(width: 5)
                }

                if (filteredDuties.contains { $0.start.isSameDay(as: day.date) }) {
                    Circle()
                        .fill(.orange)
                        .frame(width: 5)
                } else if (!monthEvents.contains { $0.startDate.isSameDay(as: day.date) }) {
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
        guard dutyDetails.isNotEmpty else { return "dutyClear" }
        guard dayIndex < dutyDetails.count else { return "dutyClear"}

        return dutyDetails[dayIndex].color
    }
}

//#Preview {
//    MonthRowView(monthEvents: <#[EKEvent]#>, adHocDuties: AdHocDuty.sampleAdHocDuties, day: CalendarDate(date: .now), selectedDate: .constant(.now))
//}


