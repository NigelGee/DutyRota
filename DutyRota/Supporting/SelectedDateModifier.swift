//
//  SelectedDateModifier.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftUI

struct SelectedDate: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    @State private var today = Date.now

    let date1: Date
    let date2: Date
    let bgColor: String

    var todayCircle: some View {
        Group {
            if date1.sameDay(as: date2) {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 200)
                    .textTint(bgColorOf: Color(bgColor))
            } else {
                EmptyView()
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .todayTextTint(date1: date1, date2: date2, bgColor: bgColor, today: $today)
            .padding(5)
            .background(todayCircle)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    today = .now
                }
            }

    }
}

extension View {
    func selected(date date1: Date, sameAs date2: Date, bgColor: String) -> some View {
        modifier(SelectedDate(date1: date1, date2: date2, bgColor: bgColor))
    }

    func todayTextTint(date1: Date, date2: Date, bgColor: String, today: Binding<Date>) -> some View {
        modifier(TodayTextTint(date1: date1, date2: date2, bgColor: bgColor, today: today))
    }
}


struct TodayTextTint: ViewModifier {
    let date1: Date
    let date2: Date
    let bgColor: String
    @Binding var today: Date

    func body(content: Content) -> some View {
        if date2.sameDay(as: today) {
            content
                .foregroundStyle(.red)
        } else {
            content
                .textTint(bgColorOf: Color(bgColor))
        }
    }
}
