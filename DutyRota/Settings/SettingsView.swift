//
//  SettingsView.swift
//  DutyRota
//
//  Created by Nigel Gee on 01/02/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday

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

                Section("More") {
                    Text("Hello World!")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
