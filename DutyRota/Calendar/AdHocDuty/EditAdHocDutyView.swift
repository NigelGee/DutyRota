//
//  EditAdHocDutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 31/01/2024.
//

import SwiftData
import SwiftUI

/// A view that is able to Add/Edit an Ad Hoc duty.
struct EditAdHocDutyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    /// A property that if user deletes a Ad Hoc duty that need to confirm that want to.
    ///
    /// Stop accidentally taps on "Delete" button.
    @State private var confirmDelete = false
    
    /// A `Binding` property of Ad Hoc Duty.
    @Bindable var adHocDuty: AdHocDuty
    var isEditing: Bool
    
    /// A computed property to show disable the "Add/Done" button if not meet requirements.
    var disableSave: Bool {
        if adHocDuty.title == "Rest" || (adHocDuty.start < adHocDuty.end && adHocDuty.title.isNotEmpty) {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
                Group {
                    HStack {
                        Text("Duty:")

                        TextField("Duty", text: $adHocDuty.title)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                    }

                    HStack {
                        Text("Route:")
                        TextField("Route", text: $adHocDuty.route)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                    }

                    Section {
                        DatePicker("Sign On", selection: $adHocDuty.start, displayedComponents: adHocDuty.title == "Rest" ? [.date] : [.date, .hourAndMinute])
                        DatePicker("Sign Off", selection: $adHocDuty.end, displayedComponents: adHocDuty.title == "Rest" ? [.date] : [.date, .hourAndMinute])

                        DatePicker("Break", selection: $adHocDuty.breakTime, displayedComponents: .hourAndMinute)

                        VStack(alignment: .leading) {
                            Toggle("Overtime", isOn: $adHocDuty.overtime)
                            Text(adHocDuty.overtime ? "This will not replace any existing duty" : "This will replace any existing duty")
                                .font(.footnote)
                        }
                    }
                }
                .disabled(adHocDuty.title == "Rest")

                Section {
                    TextField("Notes", text: $adHocDuty.notes, axis: .vertical)
                } header: {
                    Text("Notes:")
                }

                if isEditing {
                    Section {
                        LabeledContent("Time On Duty:", value: adHocDuty.tod)
                        LabeledContent("Spread", value: adHocDuty.spread)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Ad-Hoc Duty" : "Add Ad-Hoc Duty")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(isEditing ? "Done" : "Add")
                    }
                    .disabled(disableSave)
                }

                ToolbarItem(placement: .cancellationAction) {
                    if isEditing {
                        Button("Delete") {
                            confirmDelete = true
                        }
                            .foregroundStyle(.red)
                            .bold()
                    } else {
                        Button("Cancel", action: deleteDuty)
                            .foregroundStyle(.red)
                            .bold()
                    }
                }
            }
            .alert("Are you sure you want to delete this duty?", isPresented: $confirmDelete) {
                Button(role: .destructive, action: deleteDuty) {
                    Text("Delete")
                }
            }
        }
    }
    
    /// A method to delete the duty from persistent data if user "Cancel" the request.
    func deleteDuty() {
        let object = adHocDuty
        modelContext.delete(object)
        dismiss()
    }
}

//#Preview {
//    return EditAdHocDutyView(adHocDuty: AdHocDuty.sampleAdHocDuties[1], isEditing: false)
//}
