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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    @AppStorage("defaultColor") var defaultColor = "dutyGreen"
    @AppStorage("bankHolidayRule") var bankHolidayRule = true
    @AppStorage("purgeTime") var purgePeriod: PurgePeriod = .sixMonth

    @State private var showColorPicker = false

    @Query(sort: \Holiday.start) var holidays: [Holiday]
    @Query var rotas: [Rota]

    @State private var holiday: Holiday?

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section {
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

                    Picker("Start Week On:", selection: $startDayOfWeek) {
                        ForEach(WeekDay.allCases, id: \.self) {
                            Text($0.name)
                                .id($0.rawValue)
                        }
                    }
                    .disabled(rotas.isNotEmpty)
                } footer: {
                    Text("You need to have no Rotas set to able to change the Start of Week.")
                }

                Section {
                    if holidays.isNotEmpty {
                        ForEach(holidays) { holiday in
                            NavigationLink(value: holiday) {
                                if dynamicTypeSize < .xxxLarge {
                                    Text("\(holiday.start.formatted(date: .abbreviated, time: .omitted)) to \(holiday.end.formatted(date: .abbreviated, time: .omitted))")
                                } else {
                                    VStack {
                                        Text(holiday.start.formatted(date: .abbreviated, time: .omitted))
                                        Text(holiday.end.formatted(date: .abbreviated, time: .omitted))
                                    }
                                }
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

                Section {
                    Picker("Purge Ad Hoc Duties:", selection: $purgePeriod) {
                        ForEach(PurgePeriod.allCases) {
                            Text($0.purgeDescription)
                        }
                    }
                } footer: {
                    Text(purgePeriod == .never ? "This may take up memory and effect performance." : "This is to automatically delete old ad hoc duties after a \(purgePeriod.purgeDescription.lowercased()) period.")
                }

                Section {
                    Toggle("Bank Holiday Rule", isOn: $bankHolidayRule)
                } footer: {
                    Text("This will change the duty on Bank Holidays by use Sunday duties on Bank Holiday Monday and Saturday Duties on Bank Holiday Friday.")
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
