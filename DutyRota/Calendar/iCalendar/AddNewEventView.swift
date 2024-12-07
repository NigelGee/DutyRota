//
//  AddNewEventView.swift
//  DutyRota
//
//  Created by Nigel Gee on 30/01/2024.
//

import EventKit
import SwiftUI

/// a view that able to add a quick iCal event.
struct AddNewEventView: View {
    @Environment(\.dismiss) var dismiss
    var eventStore: EKEventStore

    /// A passed in method to run `loadEvent` so when added will show in calendar.
    var loadEvent: () -> Void

    @State private var title = ""
    @State private var isAllDay = false
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var notes = ""

    init(eventStore: EKEventStore, selectedDate: Date, loadEvent: @escaping () -> Void) {
        self.eventStore = eventStore
        self.loadEvent = loadEvent
        _startDate = State(wrappedValue: selectedDate)
        _endDate = State(wrappedValue: selectedDate.addingTimeInterval(3600))
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)

                Section {
                    Toggle("All Day", isOn: $isAllDay)
                    
                    if isAllDay == false {
                        DatePicker("Starts", selection: $startDate)
                        DatePicker("Ends", selection: $endDate)
                    } else {
                        DatePicker("Starts", selection: $startDate, displayedComponents: .date)
                        DatePicker("Ends", selection: $endDate, displayedComponents: .date)
                    }
                }
                
                Section {
                    TextField("Notes", text: $notes, axis: .vertical)
                } footer: {
                    Text("Event are created with your default setting.")
                }
            }
            .navigationTitle("Add New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", action: createCalendarEvent)
                        .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
    
    /// A method to create and add a event to iCal.
    func createCalendarEvent() {
        eventStore.requestFullAccessToEvents { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: self.eventStore)
                event.title = title

                event.isAllDay = isAllDay
                if isAllDay {
                    event.startDate = startDate.startOfDay
                    event.endDate = endDate.endOfDay
                } else {
                    event.startDate = startDate
                    event.endDate = endDate
                }

                event.notes = notes

                event.calendar = self.eventStore.defaultCalendarForNewEvents

                do {
                    try self.eventStore.save(event, span: .thisEvent, commit: true)

                    loadEvent()
                    dismiss()
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            } else {
                print("Access to calendar not granted or an error occurred.")
            }
        }
    }
}

//#Preview {
//    AddNewEventView(eventStore: <#T##EKEventStore#>, selectedDate: .now) { }
//}
