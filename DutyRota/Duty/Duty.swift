//
//  Duty.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/02/2024.
//

import Foundation
import SwiftData

/// A persistence model for a duty period.
@Model
final class Duty {
    var periodStart: Date = Date.now
    var periodEnd: Date = Date.now
    @Relationship(deleteRule: .cascade, inverse: \DutyDetail.duty) var dutyDetails: [DutyDetail]?

    init(periodStart: Date, periodEnd: Date) {
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.dutyDetails = []
    }
    
    /// An array of the non optional `DutyDetail`.
    var unwrappedDutyDetails: [DutyDetail] {
        dutyDetails ?? []
    }
}
