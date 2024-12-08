//
//  DutyView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftData
import SwiftUI
import TipKit

/// A view that show a list of duty periods.
struct DutyView: View {
    @Query(sort: \Duty.periodStart) var duties: [Duty]
    @Environment(\.modelContext) var modelContext
    
    /// A property that when select a duty period will show.
    @State private var duty: Duty?

    /// A property that will show a "End" or a `Date`.
    ///
    /// If true then `periodEnd` will be set to `.distantFuture`.
    @State private var isEnd = true

    /// A property to show the right Nav title in `EditDutyView`.
    @State private var isEdit = false

    /// A property to show an alert if unable to edit the period.
    @State private var isPeriodEndDateError = false

    private let swipeActionTip = SwipeActionTip()

    var body: some View {
        NavigationStack {
            Group {
                if duties.isEmpty {
                    DutyStartView()
                } else {
                    List {
                        TipView(swipeActionTip, arrowEdge: .bottom)
                            .tipBackground(.blue.opacity(0.2))

                        ForEach(duties) { duty in
                            NavigationLink(value: duty) {
                                HStack {
                                    Text(duty.periodStart.formatted(date: .abbreviated, time: .omitted))
                                    Text("-")
                                    Text(duty.periodEnd == .distantFuture ? "End" : duty.periodEnd.formatted(date: .abbreviated, time: .omitted))
                                }
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .leading) {
                                Button {
                                    editDuty(duty)
                                    swipeActionTip.invalidate(reason: .actionPerformed)
                                } label: {
                                    Text("Edit")
                                }
                                .tint(.green)
                            }
                        }
                        .onDelete(perform: deleteDuty)
                    }
                }
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
            .alert("Error in Duty End Date!", isPresented: $isPeriodEndDateError) {
                Button("Ok") { }
            } message: {
                Text("One of the duties does not have a Period End Date. To amend this by swipe to the right on the duty and change the end date.")
            }
            .onAppear {
                if duties.isNotEmpty {
                    SwipeActionTip.thresholdParameter = true
                }
            }
        }
    }
    
    /// A method that creates a new duty period.
    func addNewDuty() {
        var startDate = Date.now

        if let maxEndDate = duties.map(\.periodEnd).max() {
            if maxEndDate == .distantFuture {
                isPeriodEndDateError = true
                return
            } else {
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: maxEndDate)!
            }
        }

        isEnd = true
        isEdit = false
        let object = Duty(periodStart: startDate, periodEnd: .distantFuture)
        modelContext.insert(object)
        duty = object
    }
    
    /// A method that will determine if a duty has a end date.
    ///
    /// This will happen when swiped right on a duty period.
    /// - Parameter duty: A selected duty period.
    func editDuty(_ duty: Duty) {
        if duty.periodEnd == .distantFuture {
            isEnd = true
        } else {
            isEnd = false
        }
        isEdit = true
        self.duty = duty
    }
    
    /// A method to delete a duty period.
    ///
    /// This will happen when swiped left on a duty period.
    /// - Parameter indexSet: The index of duty period.
    func deleteDuty(_ indexSet: IndexSet) {
        for item in indexSet {
            let object = duties[item]
            modelContext.delete(object)
        }

        swipeActionTip.invalidate(reason: .actionPerformed)
    }
}

//#Preview {
//    let preview = PreviewContainer(Duty.self)
//    return DutyView()
//            .modelContainer(preview.container)
//}
