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
    @State private var rotaLines = [String]()

    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday

    @Query var rota: [Rota]

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var adHocDuties: [AdHocDuty]

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
                        .font(.caption)
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
                                 day: calendarDates[day],
                                 startDateOfCalendar: calendarDates.first!.date,
                                 selectedDate: $selectedDate
                    )
                }
            }
            .padding(.horizontal)

            Divider()
                .padding(.horizontal)
        }
        .onAppear {
            rotaLines = monthRotasDuties()
        }
        .onChange(of: selectedDate) {
            rotaLines = monthRotasDuties()
        }
    }

    func monthRotasDuties() -> [String] {
        guard let calendarFirst = calendarDates.first else { return [] }
        guard let currentRota = rota.first(where: { calendarFirst.date.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) else { return [] }
        let weeksToStartDate = Int((calendarFirst.date.dayDifference(from: currentRota.periodStart)) / 7) + 1
        var currentLine = currentRota.startRotaLine + weeksToStartDate
        let maxLineNumber = currentRota.rotaDetails.map { $0.line }.max() ?? 0
        let minLineNumber = currentRota.rotaDetails.map { $0.line }.min() ?? 0

        let remainder = (currentLine - minLineNumber) % currentRota.rotaDetails.count
        currentLine = minLineNumber + remainder

        var monthDuties = [String]()
        var end = calendarFirst.date
        var count = 0
        for i in 0 ..< 6 {
            if end <= currentRota.periodEnd {
                count = i
                guard let rotaDetail = currentRota.rotaDetails.first(where: { $0.line == currentLine }) else { continue }
                monthDuties.append(contentsOf: RotaDetail.weekDuties(of: rotaDetail, for: startDayOfWeek))
                if currentLine == maxLineNumber {
                    currentLine = minLineNumber
                } else {
                    currentLine += 1
                }
                end = end.add(day: 7)

            } else {
                end = end.add(day: 7)
                if let nextRota = rota.first(where: { end.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
                    currentLine = nextRota.startRotaLine - (count + 1) + i
                    guard let nextRotaDetail = nextRota.rotaDetails.first(where: { $0.line == currentLine} ) else { continue }
                    monthDuties.append(contentsOf: RotaDetail.weekDuties(of: nextRotaDetail, for: startDayOfWeek))
                } else {
                    monthDuties.append(contentsOf: RotaDetail.emptyWeek)
                }
            }
        }
        return monthDuties
    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
