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
                HStack {
                    Text(duty.title)
                        .font(.headline)

                    if duty.route != "" {
                        Text("- \(duty.route)")
                            .foregroundStyle(.secondary)
                    }
                    if duty.notes.isNotEmpty {
                        Image(systemName: "note.text")
                        Spacer()
                    }
                }

                ViewThatFits {
                    HStack {
                        Text("TOD: **\(duty.tod)**")
                        Spacer()
                        Text("Spread: **\(duty.spread)**")
                        Spacer()
                        Text("Break: **\(duty.breakTime.formattedTime)**")
                        Spacer()
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("TOD:")
                            Text(duty.tod)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Spread:")
                            Text(duty.spread)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Break:")
                            Text(duty.breakTime.formattedTime)
                                .bold()
                        }
                        Spacer()
                    }
                }
                .font(.caption)
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
