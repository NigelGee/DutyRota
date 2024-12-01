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

    /// A passed in property that when a iCalendar event is select
    @Binding var selectedEvent: EKEvent?
    var loadEvent: () -> Void

    var body: some View {
        ForEach(events) { event in
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
    }
}
