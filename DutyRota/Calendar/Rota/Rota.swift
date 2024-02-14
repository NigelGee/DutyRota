//
//  Rota.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import Foundation
import SwiftData

@Model
class Rota {
    var periodStart: Date
    var periodEnd: Date
    var rotaDetails: [RotaDetail]

    init(periodStart: Date, periodEnd: Date) {
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        rotaDetails = []
    }
}

