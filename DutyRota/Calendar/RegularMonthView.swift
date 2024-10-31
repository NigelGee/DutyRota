//
//  MonthView.swift
//  DutyRota
//
//  Created by Nigel Gee on 03/03/2024.
//

import EventKit
import EventKitUI
import SwiftData
import SwiftUI

struct RegularMonthView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @AppStorage("bankHolidayRule") var bankHolidayRule = true

    @Binding var selectedDate: Date
    var dutyDetails: [DutyDetail]
    var bankHolidays: [BankHolidayEvent]
    @Binding var monthEvents: [EKEvent]
    var eventStore: EKEventStore
    var loadEvent: () -> Void

    @State private var event: EKEvent?
    @State private var selectedDuty: AdHocDuty?

    @Query var adHocDuties: [AdHocDuty]
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

    var calendarDates: [CalendarDate] {
        selectedDate.datesOfMonth(with: startDayOfWeek.rawValue).map { CalendarDate(date: $0) }
    }

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.isDateInRange(start: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth) }
    }

    var body: some View {
        VStack(spacing: 2) {
            HStack {
                ForEach(WeekDay.sortedWeekDays(startOn: startDayOfWeek, full: true), id: \.self) {
                    Text($0)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 17))
                }
            }

            Divider()
                .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(0..<calendarDates.count, id: \.self) { dayIndex in
                        let dayEvents = monthEvents.filter { $0.startDate.isSameDay(as: calendarDates[dayIndex].date)}
                        VStack(spacing: 2) {
                            if calendarDates[dayIndex].date >= selectedDate.startDateOfMonth {
                                Button {
                                    selectedDate = calendarDates[dayIndex].date
                                } label: {
                                    VStack {
                                        Text(calendarDates[dayIndex].date, format: .dateTime.day())
                                            .selected(date: selectedDate, sameAs: calendarDates[dayIndex].date, bgColor: "dutyClear")
                                            .bold()
                                    }
                                }
                                .padding(.vertical, 5)
                                .buttonStyle(.plain)

                                if dutyDetails.isNotEmpty {
                                    if dayIndex < dutyDetails.count {
                                        DayDutiesRowView(dutyDetail: dutyDetails[dayIndex])
                                    }
                                }

                                if (filteredDuties.contains { $0.start.isSameDay(as: calendarDates[dayIndex].date) }) {
                                    let dayAdHocDuties = filteredDuties.filter { $0.start.isSameDay(as: calendarDates[dayIndex].date) }
                                    ForEach(dayAdHocDuties) { duty in
                                        DayAdHocDutiesRowView(duty: duty) {
                                            selectedDuty = duty
                                        }
                                    }
                                }

                                if dayEvents.isNotEmpty {
                                    ForEach(dayEvents) { dayEvent in
//                                        if dayEvent.calendar.type == .calDAV || dayEvent.calendar.type == .local {
                                        if dayEvent.calendar.isImmutable == false {
                                            Button {
                                                event = dayEvent
                                            } label: {
                                                DayEventView(event: dayEvent)
                                            }
                                            .buttonStyle(.plain)
                                            .hoverEffect()
                                        } else {
                                            DayEventView(event: dayEvent)
                                        }
                                    }
                                }
                            } else {
                                Text("")
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 6)
                        .containerRelativeFrame(.vertical) { height, axis in
                            height / 5
                        }
                        .background {
                            Group {
                                if bankHolidays.contains(where: { $0.date == calendarDates[dayIndex].date }) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.yellow, lineWidth: 3)
                                } else if holidayDates.contains(where: { $0 == calendarDates[dayIndex].date }) {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.red, lineWidth: 3)
                                } else {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.clear, lineWidth: 3)
                                }
                            }
                        }
                    }
                }

            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .sheet(item: $selectedDuty) { duty in
            EditAdHocDutyView(adHocDuty: duty, isEditing: true)
        }
        .sheet(item: $event) { event in
            EventDetailView(event: event)
//            EventEditViewController(event: event, eventStore: eventStore, loadEvent: loadEvent)
        }
    }
}

//#Preview {
//    NavigationStack {
//        MonthView(selectedDate: .constant(.now), dutyForMonth: [], dutyDetails: [], bankHolidays: [], monthEvents: .constant([]))
//            .navigationTitle("Today")
//            .navigationBarTitleDisplayMode(.inline)
//    }
//}
