//
//  VortexEffectView.swift
//  DutyRota
//
//  Created by Nigel Gee on 25/11/2024.
//

import SwiftUI
import Vortex

struct VortexEffectView: View {

    var isSnowing: Bool {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: .now)
        guard let startDate = DateComponents(calendar: calendar, year: year ,month: 12, day: 1).date else { return false }
        guard let endDate = DateComponents(calendar: calendar, year: year, month: 12, day: 31).date else { return false }
        return Date.now.isDateInRange(start: startDate, end: endDate.endOfDay)
    }

    var isNewYear: Bool {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: .now)
        guard let newYearDay = DateComponents(calendar: calendar, year: year, month: 1, day: 1).date else { return false }
        return Date.now.isSameDay(as: newYearDay)
    }

    var body: some View {
        Group {
            if isSnowing {
                VortexView(.snow) {
                    Image(.snow)
                        .tag("circle")
                }
                .ignoresSafeArea()
            }

            if isNewYear {
                VortexView(.fireworks) {
                    Circle()
                        .fill(.white)
                        .frame(width: 32)
                        .blur(radius: 5)
                        .blendMode(.plusLighter)
                        .tag("circle")
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    VortexEffectView()
}
