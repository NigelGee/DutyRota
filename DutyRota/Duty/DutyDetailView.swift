//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import TipKit

/// A view that shows details of duties of a duty period.
struct DutyDetailView: View {
    @AppStorage("defaultColor") var defaultColor = "dutyGreen"
    @Environment(\.modelContext) var modelContext

    /// A passed in duty period.
    @Bindable var duty: Duty
    
    /// A property to show add a duty detail sheet.
    @State private var showAddNewDuty = false
    
    /// A property to open a sheet to import a duty CSV file.
    @State private var isImporting = false

    /// A property to export the duties details to a file CSV.
    @State private var isExporting: Bool = false
    
    /// A property to to filter the list of duty details.
    @State private var search = ""
    
    /// A property to show an alert if error when importing a duty file.
    @State private var showErrorImporting = false

    /// A property to to show the error message in an alert.
    @State private var message = ""
    
    /// The header title of the list.
    let titles = ["Duty", "Start", "End", "Break", "ToD", "Spread"]
    let editDutyDetailTip = EditDutyDetailTip()
    
    /// The navigation title depends on when the dates of the period.
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
    
    /// A computed property to show instruction view on how to add duty details.
    var showFirstView: Bool {
        duty.unwrappedDutyDetails.count <= 3
    }
    
    /// A computed property of filtered duties depend on the `search`.
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
    
    /// A method to swipe to delete.
    /// - Parameter indexSets: Index of the duty detail row.
    func deleteDutyDetail(_ indexSets: IndexSet) {
        for item in indexSets {
            let object = filteredDutyDetails[item]
            modelContext.delete(object)
            duty.dutyDetails?.removeAll(where: { $0 == object })
        }
    }
    
    /// A method when first creating a new period added the 3 default duties which are needed to show correctly on calendar.
    func onAppearDefault() {
        guard duty.unwrappedDutyDetails.isEmpty else { return }

        let emptyDetail = DutyDetail(title: "", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyClear")
        let restDetail = DutyDetail(title: "Rest", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutySilver")
        let spareDetail = DutyDetail(title: "Spare", start: Date.zeroTime, end: Date.zeroTime, tod: Date.zeroTime, color: "dutyYellow")
        duty.dutyDetails?.append(emptyDetail)
        duty.dutyDetails?.append(restDetail)
        duty.dutyDetails?.append(spareDetail)
    }
    
    /// A method to sort and format a CSV file for import a duty file.
    /// - Parameter file: The file name.
    func importDuties(of file: String) {
        var newFile = file

        // this will change so header is not included.
        newFile = newFile.replacingOccurrences(of: "\r", with: "\n")
        newFile = newFile.replacingOccurrences(of: "\n\n", with: "\n")

        // split file in to rows.
        var rows = newFile.components(separatedBy: "\n")
        rows.removeFirst()

        for row in rows {
            let columns = row.components(separatedBy: ",")
            // make sure that the columns are the correct number either 4 or 5.
            guard columns.count >= 4 && columns.count <= 6 else { continue }
            // ignore if the duties are the default duties.
            if columns[0] == "Spare" || columns[0] == "Rest" || columns[0] == "" { continue }
            // if no color is present in import file then default color is used.
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
