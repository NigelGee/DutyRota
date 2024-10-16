//
//  EKEvent-Extension.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import EventKit

extension EKEvent: @retroactive Identifiable {
    public var id: String { calendarItemIdentifier }
}
