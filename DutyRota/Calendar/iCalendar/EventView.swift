//
//  EventView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftUI

struct EventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [EKEvent]
    var eventStore: EKEventStore
    @State private var selectedEvent: EKEvent?
    var loadEvent: () -> Void

    var body: some View {
        ForEach(events) { event in
            /// Commented out button to edit Event due to crash
//            if event.calendar.type == .calDAV || event.calendar.type == .local {
            if event.calendar.isImmutable == false {
                Button {
                    selectedEvent = event
                } label: {
                    EventRowView(event: event)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                EventRowView(event: event)
            }
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
//            EventEditViewController(event: event, eventStore: eventStore, loadEvent: loadEvent)
        }
    }
}
