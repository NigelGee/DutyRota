//
//  EventRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import EventKit
import SwiftUI

struct EventRowView: View {
    let event: EKEvent

    var body: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: 3, maxHeight: .infinity)
                .padding(.vertical, 5)
                .foregroundStyle(Color(cgColor: event.calendar.cgColor))

            if event.birthdayContactIdentifier != nil {
                Image(systemName: "birthday.cake")
                    .foregroundStyle(.red)
            }

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
                    .font(.caption)
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

//#Preview {
//    EventRowView(event: <#EKEvent#>)
//}
