//
//  MonthRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 02/02/2024.
//

import EventKit
import SwiftData
import SwiftUI

/// A view that has the calendar dates color and selected date circle.
struct MonthRowView: View {

    /// An array of iCalendar events for the month.
    var monthEvents: [EKEvent]

    /// An array of Ad Hoc Duties for the month.
    var adHocDuties: [AdHocDuty]

    /// An array of calculated `DutyDetails`.
    var dutyDetails: [DutyDetail]
    
    /// A property of `CalendarDate` of `selectedDay`.
    var day: CalendarDate
    
    /// A property of the first day of the selected calendar month.
    ///
    /// This could be before the 1st of month.
    var startDateOfCalendar: Date
    
    /// A `Binding` property of the selected Date.
    @Binding var selectedDate: Date
    
    /// An array of all the UK Bank Holidays.
    var bankHolidays: [BankHolidayEvent]
    
    /// A Swift date query of any vacation periods.
    @Query var holidays: [Holiday]
    
    /// A computed array of users vacation in individual dates.
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
    
    /// A computed array of Ad Hoc duties for the month.
    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) && $0.overtime }
    }
    
    /// A computed property from the first date of month to the `selectedDate`.
    ///
    /// The first day might be before the first date of month.
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
                        .fill(Color(.dutyAdHoc))
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
    
    /// A method that deterimes the color of the background of date.
    /// - Parameter dayIndex: The index of the day from first day of calendar.
    /// - Returns: A String the represent the color of the day.
    func color(_ dayIndex: Int) -> String {
        guard dutyDetails.isNotEmpty else { return "dutyClear" }
        guard dayIndex < dutyDetails.count else { return "dutyClear"}

        return dutyDetails[dayIndex].color
    }
}

//#Preview {
//    MonthRowView(monthEvents: <#[EKEvent]#>, adHocDuties: AdHocDuty.sampleAdHocDuties, day: CalendarDate(date: .now), selectedDate: .constant(.now))
//}


