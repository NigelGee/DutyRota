//
//  BankHoliday.swift
//  DutyRota
//
//  Created by Nigel Gee on 21/02/2024.
//

import Foundation

/// A model to decode Bank holidays from [Gov.co.uk](https://www.gov.uk/bank-holidays.json).
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


/// A Observable model to able to read Bank Holidays.
@Observable
final class BankHolidayEvent: Codable {
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
