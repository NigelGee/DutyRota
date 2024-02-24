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
    let isHoliday: Bool

    init(for color: String, isDay: Bool, isBankHoliday: Bool, isHoliday: Bool) {
        self.color = color
        self.isDay = isDay
        self.isBankHoliday = isBankHoliday
        self.isHoliday = isHoliday
    }
    
    var body: some View {
        if isDay {
            Color(color)
                .clipShape(.rect(cornerRadius: 5))
                .overlay {
                    if isHoliday {
                        Color(color == "dutyClear" ? .clear : .red).opacity(0.4)
                    }
                }

            if isBankHoliday {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.yellow, lineWidth: 3)
            } else if isHoliday {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.red, lineWidth: 3)
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.clear, lineWidth: 3)
            }
        }
    }
}

#Preview {
    ZStack {
        DutyBackground(for: "dutyBlue", isDay: true, isBankHoliday: false, isHoliday: true)
    }
    .frame(width: 100, height: 100)
}
