//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import TipKit

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

    let titles = ["Duty", "Start", "End", "Break", "ToD", "Spread"]
    let editDutyDetailTip = EditDutyDetailTip()

    var navigationTitle: String {
        let start = "\(duty.periodStart.formattedDayMonth)"
        var end = ""
        if duty.periodEnd == .distantFuture {
            end = "End"
        } else {
            end = "\(duty.periodEnd.formattedDayMonth)"
        }
        return start + " - " + end
    }

    var showFirstView: Bool {
        duty.unwrappedDutyDetails.count <= 3
    }

    var filteredDutyDetails: [DutyDetail] {
        if search.isNotEmpty {
            return duty.unwrappedDutyDetails.filter { $0.title.localizedCaseInsensitiveContains(search) }.sorted()
        }

        return duty.unwrappedDutyDetails.sorted()
    }

    var body: some View {
        Group {
            if showFirstView {
                DutyDetailStartView()
            } else {
                if filteredDutyDetails.isNotEmpty {
                    Grid {
                        GridRow {
                            ForEach(titles, id: \.self) {
                                GridFrameView(text: $0, color: .accentColor)
                            }
                        }
                        
                        TipView(editDutyDetailTip, arrowEdge: .bottom)
                            .tipBackground(.blue.opacity(0.2))
                            .padding(.horizontal)

                        ScrollView(showsIndicators: false) {
                            #warning(#"remove \.self from id when in production"#)
                            ForEach(filteredDutyDetails, id: \.self) { dutyDetail in
                                GridRow {
                                    NavigationLink(value: dutyDetail) {
                                        DetailRowView(dutyDetail: dutyDetail)
                                    }
                                }
                            }
                        }
                    }
                    .searchable(text: $search, placement: .navigationBarDrawer, prompt: "Search for a Duty.")
                    .padding(.horizontal, 5)
                } else {
                    ContentUnavailableView.search
                }
            }
        }
        .onAppear {
            if showFirstView == false {
                EditDutyDetailTip.thresholdParameter = true
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
            EditDutyDetailView(dutyDetail: dutyDetail, duty: duty)
        }
        .onAppear(perform: onAppearDefault)
        .sheet(isPresented: $showAddNewDuty) { AddDutyDetailView(duty: duty, selectedColor: defaultColor) }
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
            document: DutyDetail.makeExportFile(from: duty.unwrappedDutyDetails),
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
            duty.dutyDetails?.removeAll(where: { $0 == object })
        }
    }

    func onAppearDefault() {
        guard duty.unwrappedDutyDetails.isEmpty else { return }

        let emptyDetail = DutyDetail(title: "", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyClear")
        let restDetail = DutyDetail(title: "Rest", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutySilver")
        let spareDetail = DutyDetail(title: "Spare", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyYellow")
        duty.dutyDetails?.append(emptyDetail)
        duty.dutyDetails?.append(restDetail)
        duty.dutyDetails?.append(spareDetail)
    }

    func importDuties(of file: String) {
        var newFile = file
        newFile = newFile.replacingOccurrences(of: "\r", with: "\n")
        newFile = newFile.replacingOccurrences(of: "\n\n", with: "\n")

        var rows = newFile.components(separatedBy: "\n")
        rows.removeFirst()

        for row in rows {
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 4 && columns.count <= 6 else { continue }
            if columns[0] == "Spare" || columns[0] == "Rest" || columns[0] == "" { continue }

            let color: String
            if columns.count > 4 {
                color = columns[4].trimmed
            } else {
                color = defaultColor
            }

            let newDuty = DutyDetail(title: columns[0].trimmed, start: columns[1].formattedDate, end: columns[2].formattedDate, tod: columns[3].formattedDate, color: color)
            duty.dutyDetails?.append(newDuty)
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(DutyDetail.self, DutyDetail.self)
//    return DutyDetailView(duty: Duty.sampleDuties[0])
//        .modelContainer(preview.container)
//}
