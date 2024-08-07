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

                HStack {
                    Text("TOD: **\(dutyDetail.tod.formattedTime)**")
                    Text("Spread: **\(dutyDetail.dutySpread)**")
                    Text("Break: **\(dutyDetail.dutyBreakTime)**")
                }
                .font(.footnote)
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
