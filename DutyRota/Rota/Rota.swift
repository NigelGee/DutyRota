//
//  Rota.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import Foundation
import SwiftData

@Model
final class Rota {
    var periodStart: Date = Date.now
    var periodEnd: Date = Date.now
    var startRotaLine: Int = 0
    @Relationship(deleteRule: .cascade, inverse: \RotaDetail.rota) var rotaDetails: [RotaDetail]?

    init(periodStart: Date, periodEnd: Date, startRotaLine: Int = 0, rotaDetails: [RotaDetail] = []) {
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.startRotaLine = startRotaLine
        self.rotaDetails = rotaDetails
    }

    var unwrappedRotaDetails: [RotaDetail] {
        rotaDetails ?? []
    }

    static var example = Rota(periodStart: .now, periodEnd: .distantFuture,
                              rotaDetails: [
                                RotaDetail(line: 9999, sun: "Spare", mon: "Spare", tue: "Spare", wed: "Spare", thu: "Spare", fri: "Spare", sat: "Spare"),
                                RotaDetail(line: 9998, sun: "3701", mon: "701", tue: "", wed: "", thu: "701", fri: "1701", sat: "2701")
                              ])
}
