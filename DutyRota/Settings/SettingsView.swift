//
//  SettingsView.swift
//  DutyRota
//
//  Created by Nigel Gee on 01/02/2024.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) var modelContext
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday
    @AppStorage("defaultColor") var defaultColor = "dutyGreen"

    @State private var showColorPicker = false

    @Query(sort: \Holiday.start) var holidays: [Holiday]
    @State private var holiday: Holiday?

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section {
                    Picker("Start Week On", selection: $startDayOfWeek) {
                        ForEach(WeekDay.allCases, id: \.self) {
                            Text($0.name)
                                .id($0.rawValue)
                        }
                    }

                    LabeledContent("Default Duty Colour:") {
                        Button {
                            showColorPicker = true
                        } label: {
                            Color(defaultColor)
                                .frame(width: 30, height: 30)
                                .clipShape(.rect(cornerRadius: 5))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.primary, lineWidth: 1)
                        }
                    }
                }

                Section {
                    if holidays.isNotEmpty {
                        ForEach(holidays) { holiday in
                            NavigationLink(value: holiday) {
                                Text("\(holiday.start.formatted(date: .abbreviated, time: .omitted)) to \(holiday.end.formatted(date: .abbreviated, time: .omitted))")
                            }
                        }
                        .onDelete(perform: deleteHoliday)
                    } else {
                        ContentUnavailableView {
                            Label("No Holidays!", systemImage: "airplane.departure")
                                .symbolRenderingMode(.hierarchical)

                        } description: {
                            Text("Tap \(Image(systemName: "plus")) to add holidays.")
                        }
                    }

                } header: {
                    HStack {
                        Text("Holidays")
                        Spacer()
                        Button(action: addNewHoliday) {
                            Label("Add Holiday", systemImage: "plus")
                                .labelStyle(.iconOnly)
                        }
                    }
                }

                Section("Help") {
                    NavigationLink("How To Set Up") {
                        SetUpView()
                    }
                    NavigationLink("How To Import/Export") {
                        ImportExportView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showColorPicker) {
                ColorPickerView(selectedColor: $defaultColor)
                    .presentationDetents([.height(250)])
            }
            .navigationDestination(for: Holiday.self) { holiday in
                EditHolidayView(holiday: holiday)
            }
        }
    }

    func addNewHoliday() {
        let newHoliday = Holiday(start: .now, end: .now)
        modelContext.insert(newHoliday)
        path.append(newHoliday)
    }

    func deleteHoliday(_ indexSet: IndexSet) {
        for item in indexSet {
            let object = holidays[item]
            modelContext.delete(object)
        }
    }
}

#Preview {
    SettingsView()
}
