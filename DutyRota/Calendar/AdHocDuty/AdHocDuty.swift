//
//  AdHocDuty.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/01/2024.
//

import SwiftData
import Foundation

@Model
class AdHocDuty {
    var duty: String
    var route: String
    var start: Date
    var end: Date
    var breakTime: Date

    init(duty: String, route: String, start: Date, end: Date, breakTime: Date) {
        self.duty = duty
        self.route = route
        self.start = start
        self.end = end
        self.breakTime = breakTime
    }

    var spread: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]

        let newSpread = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

        return formatter.string(from: newSpread) ?? "Spread"
    }

    var tod: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let components = Calendar.current.dateComponents([.hour, .minute], from: breakTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        let newTOD = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate - Double(hour + minute)

        return formatter.string(from: newTOD) ?? "Time"
    }

}
