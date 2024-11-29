//
//  ContentView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftUI

struct ContentView: View {

    /// Keep track of which "Tab" the user is on.
    @AppStorage("selectedTab") var selectedTab: Tabs = .calendar

    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(Tabs.calendar)

            RotaView()
                .tabItem { Label("Rota", systemImage: "calendar.badge.clock") }
                .tag(Tabs.rota)

            DutyView()
                .tabItem { Label("Duty", systemImage: "filemenu.and.selection") }
                .tag(Tabs.duty)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(Tabs.settings)
        }
    }
}
//
//#Preview {
//    ContentView()
//}
