//
//  EditDutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 11/02/2024.
//

import SwiftUI

struct EditDutyDetailView: View {
    @Bindable var dutyDetail: DutyDetail
    @State private var showColorPicker = false

    var body: some View {
        VStack {
            LabeledContent("Duty:") {
                TextField("Duty", text: $dutyDetail.title)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
            }

            DatePicker("Sign On:", selection: $dutyDetail.start, displayedComponents: .hourAndMinute)
            DatePicker("Sign Off:", selection: $dutyDetail.end, displayedComponents: .hourAndMinute)
            DatePicker("Time On Duty:", selection: $dutyDetail.tod, displayedComponents: .hourAndMinute)

            HStack {
                Text("Duty Colour:")
                Spacer()
                Button {
                    showColorPicker = true
                } label: {
                    Color(dutyDetail.color)
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(.primary, lineWidth: 1)
                }
            }

            Spacer()
        }
        .sheet(isPresented: $showColorPicker) {
            ColorPickerView(selectedColor: $dutyDetail.color)
                .presentationDetents([.height(250)])
        }
        .padding()
    }
}

#Preview {
    EditDutyDetailView(dutyDetail: DutyDetail.example)
}
