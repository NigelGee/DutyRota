//
//  CalendarDate.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import Foundation

/// A model that is able to identify a date.
struct CalendarDate: Identifiable {
    let id = UUID()
    var date: Date
}
