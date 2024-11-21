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
    var resetControlDate: () -> Void

    @Query var adHocDuties: [AdHocDuty]

    @State private var showDetail = false

    var filteredAdHocDuty: AdHocDuty? {
        if dutyDetail.isAdHoc {
            return adHocDuties.filter({ $0.id == dutyDetail.id }).first
        }
        return nil
    }

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
                .sheet(isPresented: $showDetail, onDismiss: resetControlDate) {
                    if dutyDetail.isAdHoc {
                        EditAdHocDutyView(adHocDuty: filteredAdHocDuty ?? AdHocDuty(title: "", route: "", start: .zeroTime, end: .zeroTime, breakTime: .zeroTime), isEditing: true)
                    } else {
                        DutySheetView(dutyDetail: dutyDetail)
                    }
                }
            }
        }
    }
}

//#Preview {
//    DayDutiesRowView(dutyDetail: DutyDetail.example, controlDate: .constant(.now))
//}
