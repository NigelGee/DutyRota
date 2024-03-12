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
                .foregroundStyle(.primary)

            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(duty.title)
                        .font(.headline)
                    if duty.route != "" {
                        Text(" - \(duty.route)")
                            .foregroundStyle(.secondary)
                    }
                }
                HStack {
                    Text("TOD: **\(duty.tod)**")
                    Text("Spread: **\(duty.spread)**")
                    Text("Break: **\(duty.breakTime.formattedTime)**")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            Spacer()

            VStack {
                Text(duty.start.formattedTime)
                Text(duty.end.formattedTime)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

//#Preview {
//    AdHocDutyRowView(duty: AdHocDuty.sampleAdHocDuties[1])
//        .padding(.horizontal)
//}
