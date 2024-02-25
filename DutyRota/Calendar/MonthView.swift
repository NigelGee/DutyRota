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

    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday

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
//        .onAppear {
//            rotaLines = monthRotasDuties()
//        }
//        .onChange(of: selectedDate) {
//            rotaLines = monthRotasDuties()
//        }
    }

//    func monthRotasDuties() -> [String] {
//        var monthDuties = [String]()
//        var count = 0
//        guard let calendarFirst = calendarDates.first else { return [] }
//        guard let calendarLast = calendarDates.last else { return [] }
//        if let currentRota = rota.first(where: { calendarFirst.date.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
//            let weeksToStartDate = Int((calendarFirst.date.dayDifference(from: currentRota.periodStart)) / 7) + 1
//            var currentLine = currentRota.startRotaLine + weeksToStartDate
//            let maxLineNumber = currentRota.rotaDetails.map { $0.line }.max() ?? 0
//            let minLineNumber = currentRota.rotaDetails.map { $0.line }.min() ?? 0
//
//            let remainder = (currentLine - minLineNumber) % currentRota.rotaDetails.count
//            currentLine = minLineNumber + remainder
//
//            var end = calendarFirst.date
//
//            for i in 0 ..< 6 {
//                if end <= currentRota.periodEnd {
//                    count = i
//                    guard let rotaDetail = currentRota.rotaDetails.first(where: { $0.line == currentLine }) else { continue }
//                    monthDuties.append(contentsOf: RotaDetail.weekDuties(of: rotaDetail, for: startDayOfWeek))
//                    if currentLine == maxLineNumber {
//                        currentLine = minLineNumber
//                    } else {
//                        currentLine += 1
//                    }
//                    end = end.add(day: 7)
//
//                } else {
//                    end = end.add(day: 7)
//                    if let nextRota = rota.first(where: { end.isDateInRange(start: $0.periodStart, end: $0.periodEnd) }) {
//                        currentLine = nextRota.startRotaLine - (count + 1) + i
//                        guard let nextRotaDetail = nextRota.rotaDetails.first(where: { $0.line == currentLine} ) else { continue }
//                        monthDuties.append(contentsOf: RotaDetail.weekDuties(of: nextRotaDetail, for: startDayOfWeek))
//                    } else {
//                        monthDuties.append(contentsOf: RotaDetail.emptyWeek)
//                    }
//                }
//            }
//        } else if let currentRota = rota.first(where: { $0.periodStart.isDateInRange(start: calendarFirst.date, end: calendarLast.date) }) {
//            let numberOfWeeks = currentRota.periodStart.dayDifference(from: calendarFirst.date) / 7
//            for i in 0 ..< 6 {
//                if numberOfWeeks > i {
//                    monthDuties.append(contentsOf: RotaDetail.emptyWeek)
//                } else {
//                    let currentLine = currentRota.startRotaLine
//                    guard let rotaDetail = currentRota.rotaDetails.first(where: { $0.line == (currentLine + count) }) else { continue }
//                    monthDuties.append(contentsOf: RotaDetail.weekDuties(of: rotaDetail, for: startDayOfWeek))
//                    count += 1
//                }
//            }
//        } else {
//            return []
//        }
//        return monthDuties
//    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
