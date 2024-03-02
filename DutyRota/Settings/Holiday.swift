//
//  Holiday.swift
//  DutyRota
//
//  Created by Nigel Gee on 23/02/2024.
//

import Foundation
import SwiftData

@Model
class Holiday {
    var start: Date = Date.now
    var end: Date = Date.now

    init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }
}
