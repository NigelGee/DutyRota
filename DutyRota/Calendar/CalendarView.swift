//
//  CalendarView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftData
import SwiftUI

struct CalendarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase

    @State private var showDialog = false
    @State private var showAddAdHocDuty = false
    @State private var showAddEvent = false

    @State private var selectedDate = Date.now
    @State private var eventStore = EKEventStore()
    @State private var events = [EKEvent]()
    @State private var monthEvents = [EKEvent]()
    @State private var newDuty: AdHocDuty?

    @Query(sort: \AdHocDuty.start) var adHocDuties: [AdHocDuty]

    var filteredDuties: [AdHocDuty] {
        adHocDuties.filter { $0.start.sameDay(as: selectedDate) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                ButtonView(selectedDate: $selectedDate, showAddAdHocDuty: $showAddAdHocDuty)

                MonthView(selectedDate: $selectedDate, monthEvents: $monthEvents, duties: adHocDuties)

                if events.isNotEmpty || filteredDuties.isNotEmpty {
                    List {
                        AdHocDutyView(filteredDuties: filteredDuties)

                        EventView(events: $events)
                    }
                    .listStyle(.plain)
                } else {
                    ContentUnavailableView("No Events", systemImage: "calendar")
                }
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadEvent)
            .onChange(of: selectedDate) {
                loadEvent()
            }
            .toolbar {
                Button {
                    showDialog = true
                } label: {
                    Label("Add AdHoc", systemImage: "calendar.badge.plus")
                }
            }
            .sheet(isPresented: $showAddAdHocDuty, onDismiss: onDismiss) {
                if let newDuty {
                    EditAdHocDutyView(adHocDuty: newDuty, isEditing: false)
                }

            }
            .sheet(isPresented: $showAddEvent) {
                AddNewEventView(eventStore: eventStore, selectedDate: selectedDate, loadEvent: loadEvent)
            }
            .confirmationDialog("Add Event", isPresented: $showDialog) {
                Button {
                    addNewDuty()
                } label: {
                    Label("New Duty", systemImage: "book.pages")
                }

                Button {
                    showAddEvent = true
                } label: {
                    Label("New Event", systemImage: "calendar")
                }
            }
        }
    }

    func loadEvent() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted && error == nil {
                let calendar = Calendar.current
                let startDay = calendar.date(byAdding: .hour, value: 3, to: selectedDate.startOfDay)!

                let predicateDay = eventStore.predicateForEvents(withStart: startDay, end: selectedDate.endOfDay, calendars: nil)

                let predicateMonth = eventStore.predicateForEvents(withStart: selectedDate.startDateOfMonth, end: selectedDate.endDateOfMonth, calendars: nil)

                events = eventStore.events(matching: predicateDay)

                monthEvents = eventStore.events(matching: predicateMonth)
            } else {
                print("Error")
            }
        }
    }

    func addNewDuty() {
        var defaultBreakTime: Date {
            var components = DateComponents()
            components.hour = 1
            components.minute = 0
            return Calendar.current.date(from: components) ?? Date.now
        }

        let newDuty = AdHocDuty(duty: "", route: "", start: selectedDate, end: selectedDate.addingTimeInterval(30_960), breakTime: defaultBreakTime)
        modelContext.insert(newDuty)

        self.newDuty = newDuty

        showAddAdHocDuty = true
    }

    func onDismiss() {
        if let newDuty {
            if newDuty.duty.isEmpty {
                let object = newDuty
                modelContext.delete(object)
            }
        }
    }
}

#Preview {
    CalendarView()
}
