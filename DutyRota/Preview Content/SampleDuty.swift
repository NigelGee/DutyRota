//
//  SampleDuty.swift
//  DutyRota
//
//  Created by Nigel Gee on 07/02/2024.
//

import Foundation

extension Duty {
    static var sampleDuties: [Duty] {
        [
            Duty(periodStart: .now, periodEnd: .distantFuture)
        ]
    }
}
