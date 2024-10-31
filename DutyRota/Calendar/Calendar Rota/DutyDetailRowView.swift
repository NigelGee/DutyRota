//
//  DutyDetailRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 24/02/2024.
//

import SwiftData
import SwiftUI

struct DutyDetailRowView: View {
    var dutyDetail: DutyDetail

    var body: some View {
        HStack {
            Rectangle()
                .frame(maxWidth: 3, maxHeight: .infinity)
                .padding(.vertical, 5)
                .foregroundStyle(.primary)

            VStack(alignment: .leading) {
                Text("Duty: \(dutyDetail.title)")
                    .font(.headline)

                ViewThatFits {
                    HStack {
                        Text("TOD: **\(dutyDetail.tod.formattedTime)**")
                        Spacer()
                        Text("Spread: **\(dutyDetail.dutySpread)**")
                        Spacer()
                        Text("Break: **\(dutyDetail.dutyBreakTime)**")
                        Spacer()
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("TOD:")
                            Text(dutyDetail.tod.formattedTime)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Spread:")
                            Text(dutyDetail.dutySpread)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Break:")
                            Text(dutyDetail.dutyBreakTime)
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
                Text(dutyDetail.start.formattedTime)
                Text(dutyDetail.end.formattedTime)
                    .foregroundStyle(.secondary)
            }

        }
        .textTint(bgColorOf: Color(dutyDetail.color))
    }
}

#Preview {
    DutyDetailRowView(dutyDetail: .example)
        .padding()
        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
}
