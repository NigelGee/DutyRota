//
//  DutyDetailRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 24/02/2024.
//

import SwiftData
import SwiftUI

/// A View that duties are shown in the lists this includes rostered duties and Ad hoc.
struct DutyDetailRowView: View {

    /// An array of calculated `DutyDetails`
    var dutyDetail: DutyDetail
    
    /// An array of Ad Hoc Duties for the month.
    var adHocDuties: [AdHocDuty]

    /// A property to show details of a duty.
    ///
    /// if an Ad Hoc duty will show `EditAdHocDutyView`, if not show `DutySheetView`.
    @State private var showDetails = false
    var resetControlDate: () -> Void
    
    /// A computed property to identify a Ad Hoc to be able to edit it.
    var filteredAdHocDuties: AdHocDuty? {
        if dutyDetail.isAdHoc {
            return adHocDuties.filter { $0.id == dutyDetail.id }.first
        }
        return nil
    }

    var body: some View {
        Button {
            showDetails.toggle()
        } label: {
            HStack {
                Rectangle()
                    .frame(maxWidth: 3, maxHeight: .infinity)
                    .padding(.vertical, 5)
                    .foregroundStyle(.primary)

                VStack(alignment: .leading) {
                    HStack {
                        Text(dutyDetail.title)
                            .font(.headline)

                        if dutyDetail.route.isNotEmpty {
                            Text("- \(dutyDetail.route)")
                                .foregroundStyle(.secondary)
                        }

                        if dutyDetail.notes.isNotEmpty {
                            Image(systemName: "note.text")
                            Spacer()
                        }

                    }

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
        .sheet(isPresented: $showDetails, onDismiss: resetControlDate) {
            if dutyDetail.isAdHoc {
                EditAdHocDutyView(adHocDuty: filteredAdHocDuties ?? AdHocDuty.init(title: "Error", route: "", start: .zeroTime, end: .zeroTime, breakTime: .zeroTime), isEditing: true)
            } else {
                DutySheetView(dutyDetail: dutyDetail)
            }
        }
    }
}

#Preview {
    DutyDetailRowView(dutyDetail: .example, adHocDuties: []) { }
        .padding()
        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
}
