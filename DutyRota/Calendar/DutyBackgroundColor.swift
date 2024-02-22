//
//  DutyBackgroundColor.swift
//  DutyRota
//
//  Created by Nigel Gee on 12/02/2024.
//

import SwiftUI

struct DutyBackground: View {
    let color: String
    let isDay: Bool
    let isBankHoliday: Bool

    init(for color: String, isDay: Bool, isBankHoliday: Bool) {
        self.color = color
        self.isDay = isDay
        self.isBankHoliday = isBankHoliday
    }
    
    var body: some View {
        if isDay {
            Color(color)
                .clipShape(.rect(cornerRadius: 5))

            if isBankHoliday {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.yellow, lineWidth: 3)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.clear, lineWidth: 3)
            }
        }
    }
}

#Preview {
    ZStack {
        DutyBackground(for: "dutyBlue", isDay: true, isBankHoliday: true)
    }
    .frame(width: 100, height: 100)
}
