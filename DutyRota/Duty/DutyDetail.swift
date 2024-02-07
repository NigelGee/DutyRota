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

        let newSpread = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate

        return formatter.string(from: newSpread) ?? "Spread"
    }

    var dutyBreakTime: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        let components = Calendar.current.dateComponents([.hour, .minute], from: tod)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        let newTOD = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate - Double(hour + minute)

        return formatter.string(from: newTOD) ?? "Time"
    }

    static func <(lhs: DutyDetail, rhs: DutyDetail) -> Bool {
        lhs.title < rhs.title /*&& lhs.start < rhs.start*/
    }
}
