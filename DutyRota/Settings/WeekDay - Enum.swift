//
//  WeekDay - Enum.swift
//  DutyRota
//
//  Created by Nigel Gee on 01/02/2024.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case sunday = 0
    case monday
    case tuesday
    case wedneday
    case thursday
    case friday
    case saturday

    var name: String {
        switch self {
        case .sunday:
            "Sunday"
        case .monday:
            "Monday"
        case .tuesday:
            "Tuesday"
        case .wedneday:
            "Wednesday"
        case .thursday:
            "Thursday"
        case .friday:
            "Friday"
        case .saturday:
            "Saturday"
        }
    }

    static func sortedWeekDays(startOn weekStart: WeekDay) -> [String] {
        guard weekStart != self.sunday else { return days }

        var newDays = [String]()

        for i in weekStart.rawValue ..< WeekDay.days.count {
            newDays.append(WeekDay.days[i])
        }

        for i in 0 ..< weekStart.rawValue {
            newDays.append(WeekDay.days[i])
        }

        return newDays
    }

    static let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
}
