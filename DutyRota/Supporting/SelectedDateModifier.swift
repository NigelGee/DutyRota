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

    var foreGroundColor: Color {
        if date2.sameDay(as: today) {
            return.red
        } else if date2 < today {
            return .secondary/*.black.opacity(0.4)*/
        } else {
            return .primary/*.black*/
        }
    }

    var backgroundColor: some View {
        Group {
            if date1.sameDay(as: date2) {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 200)
            } else {
                EmptyView()
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .foregroundStyle(foreGroundColor)
            .padding(5)
            .background(backgroundColor)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    today = .now
                }
            }

    }
}

extension View {
    func selected(date date1: Date, sameAs date2: Date) -> some View {
        modifier(SelectedDate(date1: date1, date2: date2))
    }
}
