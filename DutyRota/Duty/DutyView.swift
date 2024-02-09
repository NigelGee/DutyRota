//
//  DutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftData
import SwiftUI

struct DutyView: View {
    @Query(sort: \Duty.periodStart) var duties: [Duty]
    @Environment(\.modelContext) var modelContext

    @State private var duty: Duty?
    @State private var isEnd = true
    @State private var isEdit = false
    @State private var isPeriodStartDateError = false

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
                    .onLongPressGesture {
                        if duty.periodEnd == .distantFuture {
                            isEnd = true
                        } else {
                            isEnd = false
                        }
                        isEdit = true
                        self.duty = duty
                    }
                }
                .onDelete(perform: deleteDuty)
            }
            .toolbar {
                Button(action: addNewDuty) {
                    Label("Add Duty", systemImage: "plus")
                }
            }
            .navigationTitle("Duty Period")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Duty.self) { duty in
                DutyDetailView(duty: duty)
            }
            .sheet(item: $duty) { duty in
                EditDutyView(duty: duty, isEnd: $isEnd, isEdit: $isEdit)
                    .presentationDetents([.height(210)])
            }
            .alert("Error in Duty End Date!", isPresented: $isPeriodStartDateError) {
                Button("Ok") { }
            } message: {
                Text("One of the duties does not have a Period End Date. To amend this by tap and hold on the duty and change the end date.")
            }
        }
    }

    func addNewDuty() {
        var startDate = Date.now

        let maxEndDate = duties.map { $0.periodEnd }.max()

        if maxEndDate != nil {
            if maxEndDate == .distantFuture {
                isPeriodStartDateError = true
                return
            } else {
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: maxEndDate ?? .now)!
            }
        }

        isEnd = true
        isEdit = false
        let object = Duty(periodStart: startDate, periodEnd: .distantFuture)
        modelContext.insert(object)
        duty = object
    }

    func deleteDuty(_ indexSet: IndexSet) {
        for item in indexSet {
            let object = duties[item]
            modelContext.delete(object)
        }
    }
}

#Preview {
    let preview = PreviewContainer(Duty.self)
    return DutyView()
            .modelContainer(preview.container)
}
