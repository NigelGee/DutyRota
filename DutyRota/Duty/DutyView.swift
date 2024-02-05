//
//  DutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftData
import SwiftUI

struct DutyView: View {
    @Query var duties: [Duty]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(duties) { duty in
                    NavigationLink(value: duty) {
                        HStack {
                            Text(duty.periodStart.formatted(date: .abbreviated, time: .omitted))
                            Text("-")
                            if duty.periodEnd == .distantFuture {
                                Text("End")
                            } else {
                                Text(duty.periodEnd.formatted(date: .abbreviated, time: .omitted))
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button(action: addSamples) {
                    Label("Add Sample", systemImage: "plus")
                }
            }
            .navigationTitle("Duty")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Duty.self) { duty in
                DutyDetailView(duty: duty)
            }
        }
    }

    func addSamples() {
        let object = Duty(periodStart: .now, periodEnd: .distantFuture)
        modelContext.insert(object)
    }
}

#Preview {
    DutyView()
}
