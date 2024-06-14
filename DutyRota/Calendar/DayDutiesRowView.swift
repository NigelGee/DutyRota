//
//  DayDutiesRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/03/2024.
//

import SwiftData
import SwiftUI

struct DayDutiesRowView: View {
    let dutyNumber: String
    let dutyDetails: [DutyDetail]

    @State private var showDetail = false

    var dutyDetail: DutyDetail {
        if let dayDetail = (dutyDetails.first { $0.title == dutyNumber }) {
            return dayDetail
        }

        return DutyDetail.dutyError(for: dutyNumber)
    }

    var body: some View {
        Button {
            showDetail = true
        } label: {
            HStack(spacing: 5) {
                Text(dutyDetail.title)
                    .bold()
                Spacer()

                AStack {
                    Text(dutyDetail.start, format: .dateTime.hour().minute())
                        .bold()
                    Text(dutyDetail.end, format: .dateTime.hour().minute())
                }
            }
            .font(.system(size: 12))
            .padding(5)
            .background(Color(dutyDetail.color))
            .textTint(bgColorOf: Color(dutyDetail.color))
            .clipShape(.rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .hoverEffect()
        .sheet(isPresented: $showDetail) {
            DutySheetView(dutyDetail: dutyDetail)
        }
    }
}

#Preview {
    DayDutiesRowView(dutyNumber: "701", dutyDetails: [])
}
