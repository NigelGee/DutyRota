//
//  RotaView.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import SwiftData
import SwiftUI
import TipKit

/// A view that  shows Rotas periods
struct RotaView: View {
    @Query(sort: \Rota.periodStart) var rotas: [Rota]
    @Environment(\.modelContext) var modelContext
    
    /// A property that determines if a "tip" on how to change a period.
    private let swipeActionTip = SwipeActionTip()
    
    /// A binding property that will show a `EditRotaView` sheet.
    @State private var rota: Rota?

    /// A binding property that can be toggled to show end date
    ///
    /// if `true` then `periodEnd` id set to `.distantFuture`
    @State private var isEnd = true

    @State private var isEdit = false
    @State private var isPeriodEndDateError = false

    var body: some View {
        NavigationStack {
            Group {
                if rotas.isEmpty {
                    RotaStartView()
                } else {
                    List {
                        TipView(swipeActionTip, arrowEdge: .bottom)
                            .tipBackground(.blue.opacity(0.2))

                        ForEach(rotas) { rota in
                            NavigationLink(value: rota) {
                                HStack {
                                    Text(rota.periodStart.formatted(date: .abbreviated, time: .omitted))
                                    Text("-")
                                    if rota.periodEnd == .distantFuture {
                                        Text("End")
                                    } else {
                                        Text(rota.periodEnd.formatted(date: .abbreviated, time: .omitted))
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        editRota(rota)
                                        swipeActionTip.invalidate(reason: .actionPerformed)
                                    } label: {
                                        Text("Edit")
                                    }
                                    .tint(.green)
                                }
                            }
                        }
                        .onDelete(perform: deleteRota)
                    }
                }
            }
            .toolbar {
                Button(action: addNewRota) {
                    Label("Add Rota", systemImage: "plus")
                }
            }
            .navigationTitle("Rota Period")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Rota.self) { rota in
                RotaDetailView(rota: rota)
            }
            .sheet(item: $rota) { rota in
                EditRotaView(rota: rota, isEnd: $isEnd, isEdit: $isEdit)
                    .presentationDetents([.height(210)])
            }
            .alert("Error in Duty End Date!", isPresented: $isPeriodEndDateError) {
                Button("Ok") { }
            } message: {
                Text("One of the rotas does not have a Period End Date. To amend this by swipe to right on the rota and change the end date.")
            }
            .onAppear {
                if rotas.isNotEmpty {
                    SwipeActionTip.thresholdParameter = true
                }
            }
        }
    }

    func addNewRota() {
        var startDate = Date.now

        if let maxEndDate = rotas.map(\.periodEnd).max() {
            if maxEndDate == .distantFuture {
                isPeriodEndDateError = true
                return
            } else {
                startDate = Calendar.current.date(byAdding: .day, value: 1, to: maxEndDate)!
            }
        }
        isEnd = true
        isEdit = false
        let object = Rota(periodStart: startDate, periodEnd: .distantFuture)
        modelContext.insert(object)
        rota = object
    }

    func editRota(_ rota: Rota) {
        if rota.periodEnd == .distantFuture {
            isEnd = true
        } else {
            isEnd = false
        }
        isEdit = true
        self.rota = rota
    }

    func deleteRota(_ indexSet: IndexSet) {
        for item in indexSet {
            let object = rotas[item]
            modelContext.delete(object)
        }
        swipeActionTip.invalidate(reason: .actionPerformed)
    }
}

#Preview {
    RotaView()
}
