//
//  AdHocDutySamples.swift
//  DutyRota
//
//  Created by Nigel Gee on 06/02/2024.
//

import Foundation

extension AdHocDuty {
    static var sampleAdHocDuties: [AdHocDuty] {
        var duties = [AdHocDuty]()
        var components = DateComponents()

        for i in 1 ..< 5 {
            var start: Date {
                components.day = 6
                components.month = 4
                components.year = 2024
                components.hour = 4 + i
                components.minute = 15 * i
                return Calendar.current.date(from: components)!
            }

            var end: Date {
                components.day = 6
                components.month = 4
                components.year = 2024
                components.hour = 13 + i
                components.minute = 5 * i
                return Calendar.current.date(from: components)!
            }

            var breakTime: Date {
                components.hour = 1
                components.minute = 0
                return Calendar.current.date(from: components)!
            }

            let newDuty = AdHocDuty(title: "70\(i)", route: "321", start: start, end: end, breakTime: breakTime)
            duties.append(newDuty)
        }
        return duties
    }
}
