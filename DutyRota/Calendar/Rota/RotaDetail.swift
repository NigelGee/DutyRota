//
//  RotaDetail.swift
//  DutyRota
//
//  Created by Nigel Gee on 13/02/2024.
//

import Foundation
import SwiftData

@Model
class RotaDetail {
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
}
