//
//  DutyDetail.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/02/2024.
//

import Foundation
import SwiftData

@Model
class DutyDetail: Comparable {
    var title: String
    var start: Date
    var end: Date
    var tod: Date

    init(title: String, start: Date, end: Date, tod: Date) {
        self.title = title
        self.start = start
        self.end = end
        self.tod = tod
    }

    var dutySpread: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let newSpread: Double
        if end == start {
            newSpread = 0
        } else if end > start {
            newSpread = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        } else {
            let before = start.endOfDay.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate + 1
            let after = end.timeIntervalSinceReferenceDate - end.startOfDay.timeIntervalSinceReferenceDate
            newSpread = after + before
        }
        let time = formatter.string(from: newSpread) ?? "Spread"
        return time == "0" ? "00:00" : time
    }

    var dutyBreakTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let components = Calendar.current.dateComponents([.hour, .minute], from: tod)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        let newTOD: Double

        if end == start {
            newTOD = 0
        } else if end > start {
            newTOD = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate - Double(hour + minute)
        } else {
            let before = start.endOfDay.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate + 1
            let after = end.timeIntervalSinceReferenceDate - end.startOfDay.timeIntervalSinceReferenceDate
            newTOD = before + after - Double(hour + minute)
        }
        
        let time = formatter.string(from: newTOD) ?? "Time"

        return time == "0" ? "00:00" : time
    }

    static func <(lhs: DutyDetail, rhs: DutyDetail) -> Bool {
        if lhs.title == "" {
            return false
        } else if rhs.title == "" {
            return true
        }

        return lhs.title < rhs.title
    }
}
