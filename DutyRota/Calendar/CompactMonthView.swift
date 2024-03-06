//
//  CompactMonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct CompactMonthView: View {
    var rotaLines: [String]

    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @AppStorage("bankHolidayRule") var bankHolidayRule = true

    @Query var rota: [Rota]

    @Binding var selectedDate: Date
    @Binding var monthEvents: [EKEvent]
    var adHocDuties: [AdHocDuty]
    var bankHolidays: [BankHolidayEvent]
    var dutyDetails: [DutyDetail]
    @Binding var events: [EKEvent]
    var eventStore: EKEventStore
    var loadEvent: () -> Void

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var calendarFirstDate: Date {
        guard let calendarFirst = calendarDates.first else {
            fatalError("No first date")
        }

        return calendarFirst.date
    }

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.sameDay(as: selectedDate) }
    }

    var dayDutyDetails: [DutyDetail] {
        guard rotaLines.isNotEmpty else { return [] }
        let selectedIndex = selectedDate.dayDifference(from: calendarDates.first!.date)
        guard selectedIndex < rotaLines.count else { return [] }
        if bankHolidayRule, bankHolidays.contains(where: { $0.date == selectedDate} ) {
            if selectedDate.isBankHoliday(.monday) {
                if selectedIndex - 1 > 0 {
                    if rotaLines[selectedIndex] != "" {
                        if rotaLines[selectedIndex - 1] != "" {
                            let dayDuties = dutyDetails.filter { $0.title == rotaLines[selectedIndex - 1] }
                            if dayDuties.isNotEmpty {
                                return dayDuties
                            } else {
                                return [DutyDetail.dutyError(for: rotaLines[selectedIndex])]
                            }
                        } else {
                            return [DutyDetail.spare]
                        }
                    } else {
                        return []
                    }
                } else {
                    return [DutyDetail.dutyError(for: "Check")]
                }
            } else if selectedDate.isBankHoliday(.friday) {
                if selectedIndex + 1 < rotaLines.count {
                    if rotaLines[selectedIndex] != "" {
                        if rotaLines[selectedIndex - 1] != "" {
                            let dayDuties = dutyDetails.filter { $0.title == rotaLines[selectedIndex + 1] }
                            if dayDuties.isNotEmpty {
                                return dayDuties
                            } else {
                                return [DutyDetail.dutyError(for: rotaLines[selectedIndex])]
                            }
                        } else {
                            return [DutyDetail.spare]
                        }
                    } else {
                        return []
                    }
                } else {
                    return [DutyDetail.dutyError(for: "Check")]
                }
            } else {
                if rotaLines[selectedIndex] != "" {
                    let dayDuties = dutyDetails.filter { $0.title == rotaLines[selectedIndex] }
                    if dayDuties.isNotEmpty {
                        return dayDuties
                    } else {
                        return [DutyDetail.dutyError(for: rotaLines[selectedIndex])]
                    }
                }
            }
        } else {
            if rotaLines[selectedIndex] != "" {
                let dayDuties = dutyDetails.filter { $0.title == rotaLines[selectedIndex] }
                if dayDuties.isNotEmpty {
                    return dayDuties
                } else {
                    return [DutyDetail.dutyError(for: rotaLines[selectedIndex])]
                }
            }
        }

        return []
    }

    var listsAreEmpty: Bool {
        events.isNotEmpty || filteredDuties.isNotEmpty || dayDutyDetails.isNotEmpty
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

            if listsAreEmpty {
                List {
                    ForEach(dayDutyDetails) { dayDutyDetail in
                        DutyDetailRowView(dutyDetail: dayDutyDetail)
                            .listRowBackground(Color(dayDutyDetail.color))
                    }

                    if filteredDuties.isNotEmpty {
                        AdHocDutyView(filteredDuties: filteredDuties)
                            .listRowBackground(Color.orange.opacity(0.7))
                    }

                    if events.isNotEmpty {
                        EventView(events: $events, eventStore: eventStore, loadEvent: loadEvent)
                    }
                }
                .listStyle(.plain)
            } else {
                ContentUnavailableView("No Events", systemImage: "calendar")
            }
        }
    }
}

//#Preview {
//    MonthView(selectedDate: .constant(.now), monthEvents: <#Binding<[EKEvent]>#>, duties: AdHocDuty.sampleAdHocDuties)
//}
