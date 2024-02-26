//
//  RotaDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 14/02/2024.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct RotaDetailView: View {
    @Environment(\.modelContext) var modelContext
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @Bindable var rota: Rota

    @State private var showAddNewRota = false
    @State private var isImporting = false
    @State private var isExporting = false

    @State private var showErrorImporting = false
    @State private var message = ""

    var weekDays: [String] {
        var newDays = WeekDay.sortedWeekDays(startOn: startDayOfWeek)
        newDays.insert("Line", at: 0)
        return newDays
    }

    var wrappedRotaDetails: [RotaDetail] {
        rota.rotaDetails.sorted()
    }

    var navigationTitle: String {
        let start = "\(rota.periodStart.formattedDayMonth)"
        var end = ""
        if rota.periodEnd == .distantFuture {
            end = "End"
        } else {
            end = "\(rota.periodEnd.formattedDayMonth)"
        }
        return start + " - " + end
    }

    var body: some View {
        VStack {
            List {
                LabeledContent("First Line of the Period: ") {
                    TextField("First Line", value: $rota.startRotaLine, format: .number)
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 1) {
                    Spacer()
                    ForEach(weekDays, id: \.self) {
                        Text($0)
                            .font(.system(size: 13, weight: .bold))
                            .frame(width: 33)
                        Spacer()
                    }
                }
                .padding(.trailing, 7)
                .frame(maxWidth: .infinity)

                ForEach(wrappedRotaDetails) { rotaDetail in
                    NavigationLink(value: rotaDetail) {
                        HStack {
                            Text(rotaDetail.line.formatted(.number))
                                .font(.system(size: 13))
                                .frame(width: 31, height: 30)
                            DayRotaView(rotaDetail: rotaDetail)
                        }
                    }
                }
                .onDelete(perform: deleteRotaLine)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showAddNewRota) {
            AddRotaDetailView(rota: rota)
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: RotaDetail.self) { rotaDetail in
            EditRotaDetailView(rotaDetail: rotaDetail)
        }
        .toolbar {
            Button {
                showAddNewRota = true
            } label: {
                Label("Add New Rota", systemImage: "plus")
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
        .listStyle(.plain)
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
            document: RotaDetail.makeExportFile(from: rota.rotaDetails, weekDay: startDayOfWeek),
            contentType: UTType.commaSeparatedText,
            defaultFilename: "Rota"
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

    func deleteRotaLine(_ indexSet: IndexSet) {
        for index in indexSet {
            let object = wrappedRotaDetails[index]
            modelContext.delete(object)
            rota.rotaDetails.removeAll(where: { $0 == object })
        }
    }

    func importDuties(of file: String) {
        var newFile = file
        newFile = newFile.replacingOccurrences(of: "\r", with: "\n")
        newFile = newFile.replacingOccurrences(of: "\n\n", with: "\n")

        var rows = newFile.components(separatedBy: "\n")
        rows.removeFirst()

        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            do {
                let newRota = try RotaDetail.importDuties(for: columns, on: startDayOfWeek)
                rota.rotaDetails.append(newRota)
            } catch {
                continue
            }
        }
    }
}

//#Preview {
//    let preview = PreviewContainer(Rota.self)
//    return RotaDetailView(rota: Rota.example)
//        .modelContainer(preview.container)
//}
