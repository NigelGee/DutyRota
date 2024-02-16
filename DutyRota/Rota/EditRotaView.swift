//
//  EditRotaView.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import SwiftUI

struct EditRotaView: View {
    @Bindable var rota: Rota

    @Binding var isEnd: Bool
    @Binding var isEdit: Bool

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Start Period", selection: $rota.periodStart, displayedComponents: .date)

                Toggle("to \(isEnd ? "End" : "")", isOn: $isEnd)

                if isEnd == false {
                    DatePicker("End Period", selection: $rota.periodEnd, displayedComponents: .date)
                }
            }
            .navigationTitle(isEdit ? "Edit Rota Period" : "Add Rota Period")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: isEnd, onChangeEndDate)
            .padding()
            Spacer()
        }
    }

    func onChangeEndDate() {
        if isEnd {
            rota.periodEnd = .distantFuture
        } else {
            rota.periodEnd = .now
        }
    }
}

#Preview {
    EditRotaView(rota: Rota(periodStart: .now, periodEnd: .now.addingTimeInterval(86000)), isEnd: .constant(true), isEdit: .constant(false))
}
