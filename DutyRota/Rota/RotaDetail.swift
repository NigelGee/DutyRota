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
final class RotaDetail: Comparable {
    var line: Int = 0
    var sun: String = ""
    var mon: String = ""
    var tue: String = ""
    var wed: String = ""
    var thu: String = ""
    var fri: String = ""
    var sat: String = ""

    var rota: Rota?

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

    static var emptyWeek = Array(repeating: "", count: 7)

    static func importDuties(for columns: [String], on weekDay: WeekDay) throws -> RotaDetail {
        guard columns.count >= 8 else { throw ImportError.invalidCount }
        guard let rotaLine = Int(columns[0]) else { throw ImportError.numberError}
        switch weekDay {
        case .sunday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[1].trimmed,
                mon: columns[2].trimmed,
                tue: columns[3].trimmed,
                wed: columns[4].trimmed,
                thu: columns[5].trimmed,
                fri: columns[6].trimmed,
                sat: columns[7].trimmed)
        case .monday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[7].trimmed,
                mon: columns[1].trimmed,
                tue: columns[2].trimmed,
                wed: columns[3].trimmed,
                thu: columns[4].trimmed,
                fri: columns[5].trimmed,
                sat: columns[6].trimmed)
        case .tuesday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[6].trimmed,
                mon: columns[7].trimmed,
                tue: columns[1].trimmed,
                wed: columns[2].trimmed,
                thu: columns[3].trimmed,
                fri: columns[4].trimmed,
                sat: columns[5].trimmed)
        case .wedneday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[5].trimmed,
                mon: columns[6].trimmed,
                tue: columns[7].trimmed,
                wed: columns[1].trimmed,
                thu: columns[2].trimmed,
                fri: columns[3].trimmed,
                sat: columns[4].trimmed)
        case .thursday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[4].trimmed,
                mon: columns[5].trimmed,
                tue: columns[6].trimmed,
                wed: columns[7].trimmed,
                thu: columns[1].trimmed,
                fri: columns[2].trimmed,
                sat: columns[3].trimmed)
        case .friday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[3].trimmed,
                mon: columns[4].trimmed,
                tue: columns[5].trimmed,
                wed: columns[6].trimmed,
                thu: columns[7].trimmed,
                fri: columns[1].trimmed,
                sat: columns[2].trimmed)
        case .saturday:
            return RotaDetail(
                line: rotaLine,
                sun: columns[2].trimmed,
                mon: columns[3].trimmed,
                tue: columns[4].trimmed,
                wed: columns[5].trimmed,
                thu: columns[6].trimmed,
                fri: columns[7].trimmed,
                sat: columns[1].trimmed)
        }
    }

    static func makeExportFile(from rotaDetails: [RotaDetail], weekDay: WeekDay) -> ExportDocument {
        var payload = ""
        switch weekDay {
        case .sunday:
            payload = "Line, Sun, Mon, Tue, Wed, Thu, Fri, Sat\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.sun), \(rotaDetail.mon), \(rotaDetail.tue), \(rotaDetail.wed), \(rotaDetail.thu), \(rotaDetail.fri), \(rotaDetail.sat)\n"
            }
        case .monday:
            payload = "Line, Mon, Tue, Wed, Thu, Fri, Sat, Sun\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.mon), \(rotaDetail.tue), \(rotaDetail.wed), \(rotaDetail.thu), \(rotaDetail.fri), \(rotaDetail.sat), \(rotaDetail.sun)\n"
            }
        case .tuesday:
            payload = "Line, Tue, Wed, Thu, Fri, Sat, Sun, Mon\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.tue), \(rotaDetail.wed), \(rotaDetail.thu), \(rotaDetail.fri), \(rotaDetail.sat), \(rotaDetail.sun), \(rotaDetail.mon)\n"
            }
        case .wedneday:
            payload = "Line, Wed, Thu, Fri, Sat, Sun, Mon, Tue\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.wed), \(rotaDetail.thu), \(rotaDetail.fri), \(rotaDetail.sat), \(rotaDetail.sun), \(rotaDetail.mon), \(rotaDetail.tue)\n"
            }
        case .thursday:
            payload = "Line, Thu, Fri, Sat, Sun, Mon, Tue, Wed\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.thu), \(rotaDetail.fri), \(rotaDetail.sat), \(rotaDetail.sun), \(rotaDetail.mon), \(rotaDetail.tue), \(rotaDetail.wed)\n"
            }
        case .friday:
            payload = "Line, Fri, Sat, Sun, Mon, Tue, Wed, Thu\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.fri), \(rotaDetail.sat), \(rotaDetail.sun), \(rotaDetail.mon), \(rotaDetail.tue), \(rotaDetail.wed), \(rotaDetail.thu)\n"
            }
        case .saturday:
            payload = "Line, Sat, Sun, Mon, Tue, Wed, Thu, Fri\n"
            for rotaDetail in rotaDetails {
                payload += "\(rotaDetail.line), \(rotaDetail.sat), \(rotaDetail.sun), \(rotaDetail.mon), \(rotaDetail.tue), \(rotaDetail.wed), \(rotaDetail.thu), \(rotaDetail.fri)\n"
            }
        }

        return ExportDocument(payLoad: payload)
    }

    static func weekDuties(of rotaDetail: RotaDetail, for weekDay: WeekDay) -> [String] {
        var weekDuties = [String]()
        switch weekDay {
        case .sunday:
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
        case .monday:
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
        case .tuesday:
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
        case .wedneday:
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
        case .thursday:
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
        case .friday:
            weekDuties.append(rotaDetail.fri)
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
        case .saturday:
            weekDuties.append(rotaDetail.sat)
            weekDuties.append(rotaDetail.sun)
            weekDuties.append(rotaDetail.mon)
            weekDuties.append(rotaDetail.tue)
            weekDuties.append(rotaDetail.wed)
            weekDuties.append(rotaDetail.thu)
            weekDuties.append(rotaDetail.fri)
        }
        return weekDuties
    }

    static func <(lhs: RotaDetail, rhs: RotaDetail) -> Bool {
        lhs.line < rhs.line
    }
}
