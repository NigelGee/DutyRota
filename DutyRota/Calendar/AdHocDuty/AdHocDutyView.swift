//
//  AdHocDutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/01/2024.
//

import SwiftUI

/// A view shows Ad Hoc duties.
///
/// - Important: This will only be shown if the `overtime` is `true`.
struct AdHocDutyView: View {
    @Environment(\.modelContext) var modelContext
    
    /// A computed array of `AdHocDuty` for the `selectedDate`.
    var filteredDuties: [AdHocDuty]

    /// A property that will selected Ad Hoc Duty and trigger a `EditAdHocDutyView`.
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

//#Preview {
//    AdHocDutyView(filteredDuties: AdHocDuty.sampleAdHocDuties)
//        .padding(.horizontal)
//}
