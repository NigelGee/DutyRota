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

    var body: some View {
        ForEach(events, id: \.eventIdentifier) { event in
            HStack {
                Rectangle()
                    .frame(maxWidth: 3, maxHeight: .infinity)
                    .padding(.vertical, 5)
                    .foregroundStyle(Color(cgColor: event.calendar.cgColor))

                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    if let location = event.location {
                        Text(location)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                if event.hasAlarms {
                    Image(systemName: "alarm")
                }

                VStack {
                    if event.isAllDay {
                        Text("all-day")
                    } else {
                        Text(event.startDate, format: .dateTime.hour().minute())
                        Text(event.endDate, format: .dateTime.hour().minute())
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

//#Preview {
//    EventView()
//}
