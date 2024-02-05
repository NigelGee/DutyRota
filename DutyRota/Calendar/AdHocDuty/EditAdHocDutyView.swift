//
//  EditAdHocDutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 31/01/2024.
//

import SwiftData
import SwiftUI

struct EditAdHocDutyView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @Bindable var adHocDuty: AdHocDuty
    var isEditing: Bool

    var disableSave: Bool {
        if adHocDuty.start < adHocDuty.end && adHocDuty.title.isNotEmpty {
            return false
        }
        return true
    }

    var body: some View {
        NavigationStack {
            Form {
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
                    DatePicker("Sign On", selection: $adHocDuty.start)
                    DatePicker("Sign Off", selection: $adHocDuty.end)
                    
                    DatePicker("Break", selection: $adHocDuty.breakTime, displayedComponents: .hourAndMinute)
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
                    Button(isEditing ? "Delete" : "Cancel", action: deleteDuty)
                        .foregroundStyle(.red)
                        .bold()
                }
            }
        }
    }

    func deleteDuty() {
        let object = adHocDuty
        modelContext.delete(object)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: AdHocDuty.self, configurations: config)

    let duty = AdHocDuty(title: "717", route: "321", start: .now, end: .now.addingTimeInterval(6400), breakTime: .now)

    return EditAdHocDutyView(adHocDuty: duty, isEditing: false)
        .modelContainer(container)
}
