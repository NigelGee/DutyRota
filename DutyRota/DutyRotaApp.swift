//
//  DutyRotaApp.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftData
import SwiftUI

@main
struct DutyRotaApp: App {
    var container: ModelContainer

    init() {
        let schema = Schema([AdHocDuty.self, Duty.self])
        let config = ModelConfiguration("default", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
