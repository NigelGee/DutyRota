//
//  BankHoliday.swift
//  DutyRota
//
//  Created by Nigel Gee on 21/02/2024.
//

import Foundation

struct BankHoliday: Codable {
    private enum CodingKeys: String, CodingKey {
      case englandAndWales = "england-and-wales"
    }

  var englandAndWales: EnglandAndWales
}

struct EnglandAndWales: Codable {
  var division: String
  var events: [BankHolidayEvent]
}

@Observable
class BankHolidayEvent: Codable {
    enum CodingKeys: String, CodingKey {
        case _title = "title"
        case _date = "date"
        case _notes = "notes"
        case _bunting = "bunting"
    }

  var title: String
  var date: Date
  var notes: String
  var bunting: Bool
}
