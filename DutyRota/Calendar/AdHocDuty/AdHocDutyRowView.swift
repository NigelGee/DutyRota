//
//  AdHocDutyRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 02/02/2024.
//

import SwiftUI

struct AdHocDutyRowView: View {
    var duty: AdHocDuty

    var body: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: 3, maxHeight: .infinity)
                .padding(.vertical, 5)
                .foregroundStyle(.clear)

            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(duty.duty)
                        .font(.headline)
                    if duty.route != "" {
                        Text(" - \(duty.route)")
                            .foregroundStyle(.secondary)
                    }
                }
                HStack {
                    Text("TOD: **\(duty.tod)**")
                    Text("Spread: **\(duty.spread)**")
                    Text("Break: **\(duty.breakTime.formatted(date: .omitted, time: .shortened))**")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack {
                Text(duty.start, format: .dateTime.hour().minute())
                Text(duty.end, format: .dateTime.hour().minute())
                    .foregroundStyle(.secondary)
            }
        }
    }
}

//#Preview {
//    AdHocDutyRowView()
//}
