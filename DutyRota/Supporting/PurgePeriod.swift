//
//  PurgeTime.swift
//  DutyRota
//
//  Created by Nigel Gee on 25/11/2024.
//

import Foundation

enum PurgePeriod: String, CaseIterable, Identifiable {
    case never, year, sixMonth, month

    var id: Self { self }

    var purgeDescription: String {
        switch self {
        case .never: return "Never"
        case .year: return "Year"
        case .sixMonth: return "Six Months"
        case .month: return "Month"
        }
    }
}
