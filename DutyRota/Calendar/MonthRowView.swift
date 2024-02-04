//
//  MonthRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 02/02/2024.
//

import EventKit
import SwiftUI

struct MonthRowView: View {
    var monthEvents: [EKEvent]
    var duties: [AdHocDuty]
    var day: CalendarDate

    @Binding var selectedDate: Date

    var filteredDuties: [AdHocDuty] {
        duties.filter { $0.start > selectedDate.startDateOfMonth && $0.start < selectedDate.endDateOfMonth }
    }

    var body: some View {
        VStack {
            if day.date >= selectedDate.startDateOfMonth {
                Button {
                    selectedDate = day.date
                } label: {
                    VStack {
                        Text(day.date, format: .dateTime.day())
                            .selected(date: selectedDate, sameAs: day.date)
                    }
                }
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
        }
    }
}

//#Preview {
//    MonthRowView()
//}
