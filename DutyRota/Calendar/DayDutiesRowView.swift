//
//  DayDutiesRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/03/2024.
//

import SwiftData
import SwiftUI

struct DayDutiesRowView: View {
    let dutyDetail: DutyDetail
    @State private var showDetail = false

    var body: some View {
        Group {
            if dutyDetail.title.isNotEmpty {
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
    }
}

#Preview {
    DayDutiesRowView(dutyDetail: DutyDetail.example)
}
