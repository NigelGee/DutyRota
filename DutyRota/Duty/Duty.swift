//
//  Duty.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/02/2024.
//

import Foundation
import SwiftData

@Model
class Duty {
    var periodStart: Date
    var periodEnd: Date
    @Relationship(deleteRule: .cascade) var dutyDetails: [DutyDetail]

    init(periodStart: Date, periodEnd: Date) {
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.dutyDetails = []
    }
}
