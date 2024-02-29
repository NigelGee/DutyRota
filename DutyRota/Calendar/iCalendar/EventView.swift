//
//  EventView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import EventKit
import SwiftUI

struct EventView: View {
    @Binding var events: [EKEvent]
    var eventStore: EKEventStore
    @State private var event: EKEvent?
    var loadEvent: () -> Void

    var body: some View {
        NavigationStack {
            ForEach(events) { event in
                Button {
                    if event.calendar.type == .calDAV || event.calendar.type == .local {
                        self.event = event
                    }
                } label: {
                    EventRowView(event: event)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

            }
            .sheet(item: $event, onDismiss: loadEvent) { event in
                EventEditViewController(event: event, eventStore: eventStore)
            }
        }
    }
}

//#Preview {
//    EventView(events: <#Binding<[EKEvent]>#>, eventStore: <#EKEventStore#>) { }
//}
