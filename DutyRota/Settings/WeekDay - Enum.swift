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
}
