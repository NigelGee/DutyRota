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
    var calendarDates: [CalendarDate]
    var rotas: [String]
    var day: CalendarDate
    var startDateOfCalendar: Date

    @Binding var selectedDate: Date

    @Query var duties: [Duty]

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start > selectedDate.startDateOfMonth && $0.start < selectedDate.endDateOfMonth }
    }

    var dayCount: Int {
        day.date.startOfDay.dayDifference(from: startDateOfCalendar)
    }

    var dutyDetails: [DutyDetail] {
        if let startDateOfCalendar = calendarDates.first?.date {
            if let currentDuty = duties.first(where: { startDateOfCalendar.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
                if currentDuty.periodEnd > day.date {
                    return currentDuty.dutyDetails
                }
                if let newDuty = duties.first(where: { day.date.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
                    return newDuty.dutyDetails
                }
            }
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
            .padding(.bottom, 10)
        }
        .background {
            DutyBackground(
                for: color(dayCount),
                when: day.date >= selectedDate.startDateOfMonth
            )
        }
    }

    func color(_ dayCount: Int) -> String {
        guard rotas.isNotEmpty, dutyDetails.isNotEmpty else { return "dutyClear" }

        if let dutyDetail = (dutyDetails.first { $0.title == rotas[dayCount] }) {
            return dutyDetail.color
        } else {
            return "dutyError"
        }
    }
}

//#Preview {
//    MonthRowView(monthEvents: <#[EKEvent]#>, adHocDuties: AdHocDuty.sampleAdHocDuties, day: CalendarDate(date: .now), selectedDate: .constant(.now))
//}


