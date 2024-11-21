//
//  AdHocDuty.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/01/2024.
//

import Foundation
import SwiftData

@Model
class AdHocDuty {
    var id: UUID = UUID()
    var title: String = ""
    var route: String = ""
    var start: Date = Date.now
    var end: Date = Date.now
    var breakTime: Date = Date.now
    var notes: String = ""
    var overtime: Bool = false

    init(id: UUID = UUID(), title: String, route: String, start: Date, end: Date, breakTime: Date) {
        self.id = id
        self.title = title
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

    var todDate: Date {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let components = Calendar.current.dateComponents([.hour, .minute], from: breakTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let newTOD = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate - Double(hour + minute)

        return Date(timeIntervalSinceReferenceDate: newTOD)
    }
}
