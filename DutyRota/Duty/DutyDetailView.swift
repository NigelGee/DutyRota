//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct DutyDetailView: View {
    @Environment(\.modelContext) var modelContext
    var duty: Duty

    @State private var showAddNewDuty = false
    @State private var isImporting = false

    @State private var search = ""

    var navigationTitle: String {
        let start = "\(duty.periodStart.formatted(date: .abbreviated, time: .omitted))"
        var end = ""
        if duty.periodEnd == .distantFuture {
            end = "End"
        } else {
            end = "\(duty.periodEnd.formatted(date: .abbreviated, time: .omitted))"
        }
        return start + " - " + end
    }

    var filteredDutyDetails: [DutyDetail] {
        if search.isNotEmpty {
            return duty.dutyDetails.filter { $0.title.localizedCaseInsensitiveContains(search) }
        }

        return duty.dutyDetails
    }

    var body: some View {
        List {
            if filteredDutyDetails.isNotEmpty {
                ForEach(filteredDutyDetails) { dutyDetail in
                    VStack {
                        HStack {
                            Text("Duty: **\(dutyDetail.title)**")
                            Spacer()
                            Text("Start: **\(dutyDetail.start.formattedTime)**")
                            Spacer()
                            Text("Finish: **\(dutyDetail.end.formattedTime)**")
                        }

                        HStack {
                            Text("TOD: **\(dutyDetail.tod.formattedTime)**")
                            Spacer()
                            Text("Break: **\(dutyDetail.dutyBreakTime)**")
                            Spacer()
                            Text("Spd: **\(dutyDetail.dutySpread)**")
                        }
                    }
                    .font(.callout)
                }
                .onDelete(perform: deleteDutyDetail)
            } else {
                ContentUnavailableView.search
            }
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            Button {
                showAddNewDuty = true
            } label: {
                Label("Add Duty", systemImage: "plus")
            }

            Menu {
                Button {
                    isImporting = true
                } label: {
                    Label("Import", systemImage: "tray.and.arrow.down.fill")
                }

                Button {

                } label: {
                    Label("Export", systemImage: "tray.and.arrow.up.fill")
                }
            } label: {
                Label("More", systemImage: "tray")
            }
        }
        .onAppear(perform: onAppearDefault)
        .sheet(isPresented: $showAddNewDuty) {
            EditDutyDetailView(duty: duty)
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                guard selectedFile.startAccessingSecurityScopedResource() else { return }

                guard let dataString = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }

                importDuties(of: dataString)

                selectedFile.stopAccessingSecurityScopedResource()
            } catch {
                Swift.print(error.localizedDescription)
            }
        }
        .searchable(text: $search)
    }

    func deleteDutyDetail(at offSets: IndexSet) {
        duty.dutyDetails.remove(atOffsets: offSets)
    }

    func onAppearDefault() {
        guard duty.dutyDetails.isEmpty else { return }
       
        let emptyDetail = DutyDetail(title: "", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime)
        let restDetail = DutyDetail(title: "Rest", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime)
        let spareDetail = DutyDetail(title: "Spare", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime)
        duty.dutyDetails.append(emptyDetail)
        duty.dutyDetails.append(restDetail)
        duty.dutyDetails.append(spareDetail)
    }

    func addSample() {
        var todTime: Date {
            var components = DateComponents()
            components.hour = 2
            components.minute = 0
            return Calendar.current.date(from: components)!
        }

        let dutyDetail = DutyDetail(title: "101", start: .now, end: .now.addingTimeInterval(10800), tod: todTime)
        duty.dutyDetails.append(dutyDetail)
    }

    func importDuties(of file: String) {
        var newFile = file
        newFile = newFile.replacingOccurrences(of: "\r", with: "\n")
        newFile = newFile.replacingOccurrences(of: "\n\n", with: "\n")

        var rows = newFile.components(separatedBy: "\n")
        rows.removeFirst()

        for row in rows {
            let columns = row.components(separatedBy: ",")
            let newDuty = DutyDetail(title: columns[0], start: columns[1].formattedDate, end: columns[2].formattedDate, tod: columns[3].formattedDate)
            duty.dutyDetails.append(newDuty)
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(DutyDetail.self)
//    preview.addExamples(of: Duty.sampleDuties)
//    return DutyDetailView(duty: Duty.sampleDuties[0])
//        .modelContainer(preview.container)
//}
