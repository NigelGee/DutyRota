//
//  TodayTextTint.swift
//  DutyRota
//
//  Created by Nigel Gee on 08/12/2024.
//

import SwiftUI

fileprivate struct TodayTextTint: ViewModifier {
    let date1: Date
    let date2: Date
    let bgColor: String
    @Binding var today: Date

    func body(content: Content) -> some View {
        if date2.isSameDay(as: today) {
            content
                .foregroundStyle(.red)
        } else {
            content
                .textTint(bgColorOf: Color(bgColor))
        }
    }
}

extension View {
    func todayTextTint(date1: Date, date2: Date, bgColor: String, today: Binding<Date>) -> some View {
        modifier(TodayTextTint(date1: date1, date2: date2, bgColor: bgColor, today: today))
    }
}
