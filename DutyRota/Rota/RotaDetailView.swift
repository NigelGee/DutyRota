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
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday
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
                HStack {
                    Spacer()
                    ForEach(weekDays, id: \.self) {
                        Text($0)
                            .font(.system(size: 17, weight: .bold))
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)


                ForEach(wrappedRotaDetails) { rotaDetail in
                    HStack {
                        Spacer()
                        Text(rotaDetail.line.formatted(.number))
                        DayRotaView(rotaDetail: rotaDetail)
                    }
                    .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showAddNewRota) {
            AddRotaDetailView(rota: rota)
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
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
