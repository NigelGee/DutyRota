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
        NavigationStack {
            ForEach(filteredDuties) { duty in
                Button {
                    selectedDuty = duty
                } label: {
                    AdHocDutyRowView(duty: duty)
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(item: $selectedDuty) { duty in
            EditAdHocDutyView(adHocDuty: duty, isEditing: true)
        }
    }
}

#Preview {
    AdHocDutyView(filteredDuties: AdHocDuty.sampleAdHocDuties)
        .padding(.horizontal)
}
