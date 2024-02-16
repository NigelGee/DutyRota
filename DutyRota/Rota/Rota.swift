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
    var startRotaLine: Int
    var rotaDetails: [RotaDetail]

    init(periodStart: Date, periodEnd: Date, startRotaLine: Int = 0, rotaDetails: [RotaDetail] = []) {
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.startRotaLine = startRotaLine
        self.rotaDetails = rotaDetails
    }

    static var example = Rota(periodStart: .now, periodEnd: .distantFuture,
                              rotaDetails: [
                                RotaDetail(line: 9999, sun: "Spare", mon: "Spare", tue: "Spare", wed: "Spare", thu: "Spare", fri: "Spare", sat: "Spare"),
                                RotaDetail(line: 9998, sun: "3701", mon: "701", tue: "", wed: "", thu: "701", fri: "1701", sat: "2701")
                              ])
}
