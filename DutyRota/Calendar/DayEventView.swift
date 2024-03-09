//
//  DayEventView.swift
//  DutyRota
//
//  Created by Nigel Gee on 07/03/2024.
//

import EventKit
import SwiftUI

struct DayEventView: View {
    let event: EKEvent

    var body: some View {
        HStack {
            if event.isAllDay {
                HStack {
                    Group {
                        if event.birthdayContactIdentifier != nil {
                            Image(systemName: "birthday.cake")
                                .foregroundStyle(.red)
                                .padding(.trailing, -5)
                        }

                        Text(event.title)
                    }
                    .padding(.leading, 5)
                    .padding(.vertical, 5)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(cgColor: event.calendar.cgColor))
                .clipShape(.rect(cornerRadius: 5))
                .lineLimit(1)
            } else {
                HStack {
                    Text(event.title)
                        .lineLimit(1)
                    Spacer()
                    Text(event.startDate.formattedTime)
                }
                .padding(5)
                .background(Color(cgColor: event.calendar.cgColor))
                .clipShape(.rect(cornerRadius: 5))
            }
        }
        .font(.system(size: 12))
    }
}

//#Preview {
//    DayEventView()
//}
