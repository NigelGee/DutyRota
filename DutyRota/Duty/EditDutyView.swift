//
//  EditDutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 07/02/2024.
//

import SwiftUI

struct EditDutyView: View {
    @Bindable var duty: Duty

    @Binding var isEnd: Bool
    @Binding var isEdit: Bool

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Start Period", selection: $duty.periodStart, displayedComponents: .date)

                Toggle("to \(isEnd ? "End" : "")", isOn: $isEnd)

                if isEnd == false {
                    DatePicker("End Period", selection: $duty.periodEnd, displayedComponents: .date)
                }
            }
            .navigationTitle(isEdit ? "Edit Duty Period" : "Add Duty Period")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: isEnd, onChangeEndDate)
            .padding()
            Spacer()
        }
    }

    func onChangeEndDate() {
        if isEnd {
            duty.periodEnd = .distantFuture
        } else {
            duty.periodEnd = .now
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(Duty.self)
//    return EditDutyView(duty: Duty.sampleDuties[0],isEnd: .constant(true) ,isEdit: .constant(false))
//        .modelContainer(preview.container)
//}
