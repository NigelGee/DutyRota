//
//  EventDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 19/03/2024.
//

import EventKit
import SwiftUI

/// A view that shows iCal events in detail.
struct EventDetailView: View {
    @Environment(\.dismiss) var dismiss

    /// A passed in property of the selected iCal event.
    let event: EKEvent

    var body: some View {
        NavigationStack {
            List {
                if let location = event.location {
                    Text(location)
                        .foregroundStyle(.red)
                }

                Section {
                    if event.isAllDay {
                        VStack {
                            LabeledContent("All Day on:", value: event.startDate.formatted(date: .abbreviated, time: .omitted))
                            if event.startDate.startOfDay != event.endDate.startOfDay {
                                LabeledContent("to:", value: event.endDate.formatted(date: .abbreviated, time: .omitted))
                            }
                        }
                    } else {
                        VStack {
                            LabeledContent("From:", value: event.startDate.formatted(date: .abbreviated, time: .shortened))
                            LabeledContent("To:", value: event.endDate.formatted(date: .abbreviated, time: .shortened))
                        }
                    }

                    HStack {
                        Text("Calendar:")
                        Spacer()
                        Circle()
                            .frame(width: 10)
                            .foregroundStyle(Color(cgColor: event.calendar.cgColor))
                        Text(event.calendar.title)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    if let alarms = event.alarms {
                        ForEach(alarms, id: \.self) { alarm in
                            if alarm.relativeOffset == 0 {
                                LabeledContent("Alert:", value: "At time of event")
                            } else {
                                LabeledContent("Alert:", value: text(alarm))
                            }
                        }
                    }
                }

                Section {
                    if let notes = event.notes {
                        VStack(alignment: .leading) {
                            Text("Notes:")
                            Text(notes)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

            }
            .navigationTitle(event.title)
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
    
    /// A method to convert `EKAlarm` to `String` format.
    /// - Parameter alarm: An Alarm time taken from `EKEvent`.
    /// - Returns: A `String` format to able to display the alarm time.
    func text(_ alarm: EKAlarm) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month, .weekOfMonth, .day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        return ("\(formatter.string(from: abs(alarm.relativeOffset)) ?? "") before")
    }
}

//#Preview {
//    EventDetailView()
//}


