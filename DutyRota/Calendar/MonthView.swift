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
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var duties: [AdHocDuty]

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var wrappedWeekDays: [String] {
        guard startDayOfWeek.rawValue != 0 else { return days }
        var newDays = [String]()

        for i in startDayOfWeek.rawValue..<days.count {
            newDays.append(days[i])
        }

        for i in 0..<startDayOfWeek.rawValue {
            newDays.append(days[i])
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
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: AdHocDuty.self, configurations: config)
//
//    let duty = AdHocDuty(duty: "717", route: "321", start: .now, end: .now.addingTimeInterval(6400), breakTime: .now)
//    return MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: [duty])
//        .modelContainer(container)
//}
