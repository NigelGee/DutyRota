//
//  AdHocDutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/01/2024.
//

import SwiftUI

struct AdHocDutyView: View {
    @Environment(\.modelContext) var modelContext

    var filteredDuties: [AdHocDuty]
    
    @State private var showEditAdHocView = false
    @State private var selectedDuty: AdHocDuty?

    var body: some View {
        if filteredDuties.isNotEmpty {
            NavigationStack {

                ForEach(filteredDuties) { duty in
                    Button {
                        selectedDuty = duty
                    } label: {
                        AdHocDutyRowView(duty: duty)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteAdHocDuty)
                .sheet(item: $selectedDuty) { duty in
                    EditAdHocDutyView(adHocDuty: duty, isEditing: true)
                }
            }
            .listRowBackground(Color.orange.opacity(0.7))
        }
    }

    func deleteAdHocDuty(_ indexSet: IndexSet) {
        for item in indexSet {
            let object = filteredDuties[item]
            modelContext.delete(object)
        }
    }
}

//#Preview {
//    AdHocDutyView(selectedDate: .constant(.now))
//}
