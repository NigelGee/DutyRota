//
//  SelectedDateModifier.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftUI

struct SelectedDate: ViewModifier {
    let date1: Date
    let date2: Date

    var foreGroundColor: Color {
        if date2.sameDay(as: .now) {
            return.red
        } else if date2 < .now {
            return .secondary
        } else {
            return .primary
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
            .foregroundStyle(foreGroundColor)
            .padding(5)
            .background(backgroundColor)

    }
}

extension View {
    func selected(date date1: Date, sameAs date2: Date) -> some View {
        modifier(SelectedDate(date1: date1, date2: date2))
    }
}
