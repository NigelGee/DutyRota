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
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var duties: [AdHocDuty]

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var wrappedWeekDays: [String] {
        guard startDayOfWeek.rawValue != 0 else { return WeekDay.days }
        var newDays = [String]()

        for i in startDayOfWeek.rawValue ..< WeekDay.days.count {
            newDays.append(WeekDay.days[i])
        }

        for i in 0 ..< startDayOfWeek.rawValue {
            newDays.append(WeekDay.days[i])
        }

        return newDays
    }

    var body: some View {
        HStack {
            ForEach(wrappedWeekDays, id: \.self) {
                Text($0)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
        }
        .padding(.horizontal)

        Divider()
            .padding(.horizontal)
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(calendarDates) { day in
                    MonthRowView(monthEvents: monthEvents, duties: duties, day: day, selectedDate: $selectedDate)
                }
            }
            .padding(.horizontal)

        Divider()
            .padding(.horizontal)
    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
