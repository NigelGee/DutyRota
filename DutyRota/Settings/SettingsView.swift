//
//  SettingsView.swift
//  DutyRota
//
//  Created by Nigel Gee on 01/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday
    @AppStorage("defaultColor") var defaultColor = "dutyGreen"

    @State private var showColorPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Week Start") {
                    Picker("Start Week On", selection: $startDayOfWeek) {
                        ForEach(WeekDay.allCases, id: \.self) {
                            Text($0.name)
                                .id($0.rawValue)
                        }
                    }
                }

                Section("Colours") {
                    HStack {
                        Text("Default Duty Colour:")
                        Spacer()
                        Button {
                            showColorPicker = true
                        } label: {
                            Color(defaultColor)
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.primary, lineWidth: 1)
                        }
                    }
                }

                Section {
                    NavigationLink("How to Import/Export") {
                        InstructionView()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showColorPicker) {
                ColorPickerView(selectedColor: $defaultColor)
                    .presentationDetents([.height(250)])
            }
        }
    }
}

#Preview {
    SettingsView()
}
