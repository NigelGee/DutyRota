//
//  DutyBackground.swift
//  DutyRota
//
//  Created by Nigel Gee on 12/02/2024.
//

import SwiftUI

/// A view that gives a color and border to dates in Calendar.
struct DutyBackground: View {

    /// The color from `DutyDetail` or `iCal`.
    let color: String

    /// A `Bool` to determine if day is before start day of month.
    let isDay: Bool

    /// A `Bool` to determine if day is a Bank Holiday day..
    let isBankHoliday: Bool

    /// A `Bool` to determine if day is a vacation day.
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
                .opacity(isHoliday ? 0.4 : 1)

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

//#Preview {
//    ZStack {
//        DutyBackground(for: "dutyBlue", isDay: true, isBankHoliday: false, isHoliday: true)
//    }
//    .frame(width: 100, height: 100)
//}
