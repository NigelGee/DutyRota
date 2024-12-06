//
//  EventView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftUI

/// A view that show iCal Events for a `selectedDate`.
///
/// An event can only be edited if the event `isImmutable`.
struct EventView: View {
    @Environment(\.dismiss) var dismiss

    /// An array passed in of Event for the day.
    var events: [EKEvent]
    var eventStore: EKEventStore

    /// A passed in property that when a iCalendar event is select
    @Binding var selectedEvent: EKEvent?
    var loadEvent: () -> Void

    var body: some View {
        ForEach(events) { event in
//            if event.calendar.type == .calDAV || event.calendar.type == .local {
                if event.calendar.isImmutable == false {
                    Button {
                        selectedEvent = event
                    } label: {
                        EventRowView(event: event)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
//                }
            } else {
                EventRowView(event: event)
            }
        }
    }
}
