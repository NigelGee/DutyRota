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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AdHocDuty.self)
    }
}
