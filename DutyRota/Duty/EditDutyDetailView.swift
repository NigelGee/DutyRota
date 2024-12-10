//
//  EditDutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 11/02/2024.
//

import SwiftUI

/// A view that able user to edit a duty.
struct EditDutyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    /// A property that duty details to be edited.
    @Bindable var dutyDetail: DutyDetail

    /// The property that the detail duty belongs to.
    @Bindable var duty: Duty

    /// A property that will show the `ColorPickerView`
    @State private var showColorPicker = false

    /// A property that will get user to confirm to delete a duty detail.
    @State private var showDeleteAlert = false
    
    /// A computed property that make "Rest", "Spare" and "" not be editable expect for color and notes.
    var isDisabled: Bool {
        dutyDetail.title == "Rest" || dutyDetail.title == "Spare" || dutyDetail.title == ""
    }

    var body: some View {
        VStack {
            Group {
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
            }
            .disabled(isDisabled)

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

            VStack(alignment: .leading) {
                TextField("Notes:", text: $dutyDetail.notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.leading)
                Text("Notes that added to duties will not be exported.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
            .disabled(isDisabled)
        }
        .alert("Are You Sure?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }

            Button("OK", role: .destructive, action: deleteDuty) 

        } message: {
            Text("This will permanently delete the duty.")
        }
    }
    
    /// A method that delete the duty detail from persistence data.
    func deleteDuty() {
        modelContext.delete(dutyDetail)
        duty.dutyDetails?.removeAll(where: { $0 == dutyDetail })
        dismiss()
    }
}

//#Preview {
//    EditDutyDetailView(dutyDetail: DutyDetail.example)
//}
