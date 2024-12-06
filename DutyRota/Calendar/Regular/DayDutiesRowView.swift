//
//  DayDutiesRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/03/2024.
//

import SwiftData
import SwiftUI

/// A view that shows a duty or Ad Hoc duty.
struct DayDutiesRowView: View {

    /// A passed in array that hold duty details for the month.
    let dutyDetail: DutyDetail

    /// A passed in method that will set the `controlDate` to `.distantPast`.
    var resetControlDate: () -> Void

    @Query var adHocDuties: [AdHocDuty]
    
    /// A property to show details of a duty.
    ///
    /// if an Ad Hoc duty will show `EditAdHocDutyView`, if not show `DutySheetView`.
    @State private var showDetail = false
    
    /// A computed property that works out if a duty is an Ad Hoc duty else `nil`.
    var filteredAdHocDuty: AdHocDuty? {
        if dutyDetail.isAdHoc {
            return adHocDuties.filter { $0.id == dutyDetail.id }.first
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
                        .isPresented(for: dutyDetail.title != "Rest")
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

#Preview {
    DayDutiesRowView(dutyDetail: DutyDetail.example) { }
}
