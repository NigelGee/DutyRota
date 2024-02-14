//
//  ContentView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            RotaView()
                .tabItem { Label("Rota", systemImage: "calendar.badge.clock") }

            DutyView()
                .tabItem { Label("Duty", systemImage: "filemenu.and.selection") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    ContentView()
}
