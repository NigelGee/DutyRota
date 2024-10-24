//
//  EditDutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 11/02/2024.
//

import SwiftUI

struct EditDutyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Bindable var dutyDetail: DutyDetail
    @Bindable var duty: Duty
    @State private var showColorPicker = false
    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            LabeledContent("Duty:") {
                TextField("Duty", text: $dutyDetail.title)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 72)
                    .bold()
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
                        .frame(width: 71, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 7)
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
        .toolbar {
            Button("Delete", systemImage: "trash.fill", role: .destructive) {
                showDeleteAlert.toggle()
            }
            .tint(.red)
        }
        .alert("Are You Sure?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }

            Button("OK", role: .destructive, action: deleteDuty) 

        } message: {
            Text("This will permanently delete the duty.")
        }
    }

    func deleteDuty() {
        modelContext.delete(dutyDetail)
        duty.dutyDetails?.removeAll(where: { $0 == dutyDetail })
        dismiss()
    }
}

//#Preview {
//    EditDutyDetailView(dutyDetail: DutyDetail.example)
//}
