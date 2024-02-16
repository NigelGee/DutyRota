//
//  RotaDetail.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import Foundation
import SwiftData

enum ImportError: Error {
    case invalidCount, numberError
}

@Model
class RotaDetail: Comparable {
    var line: Int
    var sun: String
    var mon: String
    var tue: String
    var wed: String
    var thu: String
    var fri: String
    var sat: String

    init(line: Int, sun: String, mon: String, tue: String, wed: String, thu: String, fri: String, sat: String) {
        self.line = line
        self.sun = sun
        self.mon = mon
        self.tue = tue
        self.wed = wed
        self.thu = thu
        self.fri = fri
        self.sat = sat
    }

    func makeMonthDuties(startLine: Int, for weekDay: WeekDay) -> [String] {
        var monthDuties = [String]()

        for i in 0..<6 {
            monthDuties.append(contentsOf: switchOn(line: startLine + i, for: weekDay))
            self.line += 1
        }

        return monthDuties
    }

    static func importDuties(for columns: [String], on weekDay: WeekDay) throws -> RotaDetail {
        guard columns.count >= 8 else { throw ImportError.invalidCount }
        guard let rotaLine = Int(columns[0]) else { throw ImportError.numberError}
        switch weekDay {
        case .sunday:
            return RotaDetail(line: rotaLine, sun: columns[1], mon: columns[2], tue: columns[3], wed: columns[4], thu: columns[5], fri: columns[6], sat: columns[7])
        case .monday:
            return RotaDetail(line: rotaLine, sun: columns[2], mon: columns[3], tue: columns[4], wed: columns[5], thu: columns[6], fri: columns[7], sat: columns[1])
        case .tuesday:
            return RotaDetail(line: rotaLine, sun: columns[3], mon: columns[4], tue: columns[5], wed: columns[6], thu: columns[7], fri: columns[1], sat: columns[2])
        case .wedneday:
            return RotaDetail(line: rotaLine, sun: columns[4], mon: columns[5], tue: columns[6], wed: columns[7], thu: columns[1], fri: columns[2], sat: columns[3])
        case .thursday:
            return RotaDetail(line: rotaLine, sun: columns[5], mon: columns[6], tue: columns[7], wed: columns[1], thu: columns[2], fri: columns[3], sat: columns[4])
        case .friday:
            return RotaDetail(line: rotaLine, sun: columns[6], mon: columns[7], tue: columns[1], wed: columns[2], thu: columns[3], fri: columns[4], sat: columns[5])
        case .saturday:
            return RotaDetail(line: rotaLine, sun: columns[7], mon: columns[1], tue: columns[2], wed: columns[3], thu: columns[4], fri: columns[5], sat: columns[6])
        }
    }

    func switchOn(line: Int, for weekDay: WeekDay) -> [String] {
        var weekDuties = [String]()
        switch weekDay {
        case .sunday:
            weekDuties.append(sun)
            weekDuties.append(mon)
            weekDuties.append(tue)
            weekDuties.append(wed)
            weekDuties.append(thu)
            weekDuties.append(fri)
            weekDuties.append(sat)
        case .monday:
            weekDuties.append(mon)
            weekDuties.append(tue)
            weekDuties.append(wed)
            weekDuties.append(thu)
            weekDuties.append(fri)
            weekDuties.append(sat)
            weekDuties.append(sun)
        case .tuesday:
            weekDuties.append(tue)
            weekDuties.append(wed)
            weekDuties.append(thu)
            weekDuties.append(fri)
            weekDuties.append(sat)
            weekDuties.append(sun)
            weekDuties.append(mon)
        case .wedneday:
            weekDuties.append(wed)
            weekDuties.append(thu)
            weekDuties.append(fri)
            weekDuties.append(sat)
            weekDuties.append(sun)
            weekDuties.append(mon)
            weekDuties.append(tue)
        case .thursday:
            weekDuties.append(thu)
            weekDuties.append(fri)
            weekDuties.append(sat)
            weekDuties.append(sun)
            weekDuties.append(mon)
            weekDuties.append(tue)
            weekDuties.append(wed)
        case .friday:
            weekDuties.append(fri)
            weekDuties.append(sat)
            weekDuties.append(sun)
            weekDuties.append(mon)
            weekDuties.append(tue)
            weekDuties.append(wed)
            weekDuties.append(thu)
        case .saturday:
            weekDuties.append(sat)
            weekDuties.append(sun)
            weekDuties.append(mon)
            weekDuties.append(tue)
            weekDuties.append(wed)
            weekDuties.append(thu)
            weekDuties.append(fri)
        }
        return weekDuties
    }

    static func <(lhs: RotaDetail, rhs: RotaDetail) -> Bool {
        lhs.line < rhs.line
    }
}
