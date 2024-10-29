//
//  Date-Helper.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import Foundation

extension Date {

    /// Return start of day of a give date
    var startOfDay: Date {
        let calendar = Calendar.current
        guard let date = calendar.date(from: calendar.dateComponents([.day, .month, .year], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }
    
    /// Return end of day of a give date
    var endOfDay: Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: self.startOfDay) else {
            fatalError("Unable to get start date from date")
        }

        return date
    }
    
    /// Returns  the start date of the month from a given date.
    /// - Returns:A `Date` from a given `Date`
    ///
    /// `let startOfCurrentMonth = Date.now.startDateOfMonth`
    public var startDateOfMonth: Date {
        let calendar = Calendar.current
        guard let date = calendar.date(from: calendar.dateComponents([.month, .year], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    /// Returns the end date of the month from given date.
    /// - Returns: A `Date` from a given `Date`
    ///
    /// `let endOfCurrentMonth = Date.now.endDateOfMonth`
    public var endDateOfMonth: Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: DateComponents(month: 1, second: -1), to: self.startDateOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }

    var formattedTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    var formattedDayMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: self)
    }
    static var zeroTime: Date {
        var components = DateComponents()
        components.hour = 0
        components.minute = 0
        return Calendar.current.date(from: components)!
    }

    func isBankHoliday(_ weekDay: WeekDay) -> Bool {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: self)

        return dayOfWeek == (weekDay.rawValue + 1)
    }

    /// Returns a date by add a number of days to given date.
    /// - Parameter day: A number to advance the date by.
    /// - Returns: A `Date` with  number of day(s) added.
    ///
    /// `let fiveDayFromToday = Date.now.add(day: 5)`.
    ///
    /// By using minus number will return a date before given date.
    public func add(day: Int) -> Date {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: DateComponents(day: day), to: self) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    /// A method that give all the days in a month
    /// - Parameter weekStart: Start of the week
    /// - Returns: An Array of dates in a month + dates preceding the first of month
    public func datesOfMonth(with weekStart: Int) -> [Date] {
        let calendar = Calendar.current
        var dates = [Date]()

        let startOfMonth = self.startDateOfMonth
        let endOfMonth = self.endDateOfMonth

        var firstDayOfWeek = calendar.component(.weekday, from: startOfMonth)

        if weekStart < firstDayOfWeek {
            firstDayOfWeek -= weekStart
        } else {
            firstDayOfWeek += 7 - weekStart
        }

        for i in 1 ..< firstDayOfWeek {
            let reversed = firstDayOfWeek - i
            let newDate = calendar.date(byAdding: .day, value: -reversed, to: startOfMonth)!
            dates.append(newDate)
        }

        var newDate = startOfMonth
        while newDate <= endOfMonth {
            dates.append(newDate)
            newDate = calendar.date(byAdding: .day, value: 1, to: newDate)!
        }

        return dates
    }


    /// a method to check if a day is the same as another day
    /// - Parameter date: Comparison date use `.now` for today
    /// - Returns: `true` if in the same day
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }

    /// a method to check if a day is the same as another day
    /// - Parameter date: Comparison date use `.now` for today
    /// - Returns: `true` if in the same day
    func isSameMonth(as date: Date) -> Bool {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let selectedMonth = calendar.component(.month, from: date)
        return currentMonth == selectedMonth
    }

    /// Returns a Boolean value indicating whether the given date is contained within the range.
    /// - Parameters:
    ///   - start: First `Date` of the range.
    ///   - end: Last `Date` of the range..
    /// - Returns: `true` if the given date is within range, otherwise `false`
    ///
    ///  The start `Date` must be before end `Date` else will also return `false`
    public func isDateInRange(start: Date, end: Date) -> Bool {
        guard start < end else { return false }
        let range = start...end
        return range.contains(self)
    }

    /// Returns the day difference between a date and given date is the ending date.
    /// - Parameter date: The starting date components.
    /// - Returns: A `Int` of calculating the difference from start to given date.
    public func dayDifference(from date: Date) -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day], from: date, to: self)
        guard let day = component.day else {
            fatalError("Unable to get start date from date")
        }
        return day
    }

    /// Returns the day difference between a date and given date is the ending date.
    /// - Parameter date: The starting date components.
    /// - Returns: A `Int` of calculating the difference from start to given date.
    public func weekDifference(from date: Date) -> Int {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.weekOfMonth], from: date, to: self)
        guard let day = component.day else {
            fatalError("Unable to get start date from date")
        }
        return day
    }
}

extension String {
    var formattedDate: Date {
        var string = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if string.isEmpty {
            string = "00:00"
        }
        return dateFormatter.date(from: string) ?? .now
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
