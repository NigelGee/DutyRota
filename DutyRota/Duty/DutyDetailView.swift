//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct DutyDetailView: View {
    @AppStorage("defaultColor") var defaultColor = "dutyGreen"
    @Environment(\.modelContext) var modelContext
    @Bindable var duty: Duty

    @State private var showAddNewDuty = false

    @State private var isImporting = false
    @State private var isExporting: Bool = false

    @State private var search = ""

    @State private var showErrorImporting = false
    @State private var message = ""

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
            return duty.dutyDetails.filter { $0.title.localizedCaseInsensitiveContains(search) }.sorted()
        }

        return duty.dutyDetails.sorted()
    }

    var body: some View {
        List {
            if filteredDutyDetails.isNotEmpty {
                ForEach(filteredDutyDetails) { dutyDetail in
                    NavigationLink(value: dutyDetail) {
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
                        .font(.system(size: 16))
                    }
                    .listRowBackground(Color(dutyDetail.color))
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

            Menu("More", systemImage: "tray") {
                Button {
                    isImporting = true
                } label: {
                    Label("Import", systemImage: "tray.and.arrow.down")
                }

                Button {
                    isExporting = true
                } label: {
                    Label("Export", systemImage: "tray.and.arrow.up")
                }
            }
        }
        .navigationDestination(for: DutyDetail.self) { dutyDetail in
            EditDutyDetailView(dutyDetail: dutyDetail)
        }
        .onAppear(perform: onAppearDefault)
        .sheet(isPresented: $showAddNewDuty) { AddDutyDetailView(duty: duty, selectedColor: defaultColor) }
        .searchable(text: $search)
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
                message = "\(error.localizedDescription)"
                showErrorImporting = true
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: DutyDetail.makeExportFile(from: duty.dutyDetails),
            contentType: UTType.commaSeparatedText,
            defaultFilename: "Duties"
        ) { result in
            if case .success = result {
                Swift.print("Success!")
            } else {
                Swift.print("Something went wrong…")
            }
        }
        .alert("Error in Importing file", isPresented: $showErrorImporting) {
            Button("Ok") { }
        } message: {
            Text(message)
        }
    }

    func deleteDutyDetail(_ indexSets: IndexSet) {
        for item in indexSets {
            let object = filteredDutyDetails[item]
            modelContext.delete(object)
            duty.dutyDetails.removeAll(where: { $0 == object })
        }
    }

    func onAppearDefault() {
        guard duty.dutyDetails.isEmpty else { return }
       
        let emptyDetail = DutyDetail(title: "", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyClear")
        let restDetail = DutyDetail(title: "Rest", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutySilver")
        let spareDetail = DutyDetail(title: "Spare", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyYellow")
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
            guard columns.count >= 4 else { continue }
            guard columns[0] != "Spare" || columns[0] != "Rest" || columns[0] != "" else { continue }
            
            let color: String
            if columns.count > 4 {
                color = columns[4]
            } else {
                color = defaultColor
            }

            let newDuty = DutyDetail(title: columns[0], start: columns[1].formattedDate, end: columns[2].formattedDate, tod: columns[3].formattedDate, color: color)
            duty.dutyDetails.append(newDuty)
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(DutyDetail.self, DutyDetail.self)
//    return DutyDetailView(duty: Duty.sampleDuties[0])
//        .modelContainer(preview.container)
//}
