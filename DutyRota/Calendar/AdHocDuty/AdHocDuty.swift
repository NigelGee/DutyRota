//
//  AdHocDuty.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/01/2024.
//

import Foundation
import SwiftData

/// A persistence model of Ad Hoc duty.
@Model
final class AdHocDuty {
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
    
    /// A computed property that calculates the total spread of a duty. Returns as a `String` format.
    var spread: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]

        let newSpread = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

        return formatter.string(from: newSpread) ?? "Spread"
    }
    
    /// A computed property that calculates the time on duty of a duty. Returns as a `String` format.
    var tod: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let components = Calendar.current.dateComponents([.hour, .minute], from: breakTime)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        let newTOD = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate - Double(hour + minute)

        return formatter.string(from: newTOD) ?? "Time"
    }
    
    /// A computed property that calculates the time on duty of a duty. Returns as a `Date` format.
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
