//
//  DutySheetView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/03/2024.
//

import SwiftUI

/// A view that will show details of a duty.
///
/// This is read only. Duties can not be changed from here.
struct DutySheetView: View {
    @Environment(\.dismiss) var dismiss
    var dutyDetail: DutyDetail

    var body: some View {
        NavigationStack {
            List {
                LabeledContent("Duty:", value: dutyDetail.title)
                Section {
                    LabeledContent("Sign On:", value: dutyDetail.start.formattedTime)
                    LabeledContent("Sign Off:", value: dutyDetail.end.formattedTime)
                }

                Section {
                    LabeledContent("Time On Duty:", value: dutyDetail.tod.formattedTime)
                    LabeledContent("Break:", value: dutyDetail.dutyBreakTime)
                    LabeledContent("Spread:", value: dutyDetail.dutySpread)
                }

                if dutyDetail.notes.isNotEmpty {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Notes:")
                            Text(dutyDetail.notes)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .font(.title2)
            .navigationTitle("Duty Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    DutySheetView(dutyDetail: .example)
}
