//
//  RotaTextField.swift
//  DutyRota
//
//  Created by Nigel Gee on 16/02/2024.
//

import SwiftUI

struct RotaTextField: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday
    var dayTextfield: [DayTextField]
    @Binding var sunRota: String
    @Binding var monRota: String
    @Binding var tueRota: String
    @Binding var wedRota: String
    @Binding var thuRota: String
    @Binding var friRota: String
    @Binding var satRota: String

    var body: some View {
        HStack {
            ForEach(Array(sortedRotaTextfields(day: startDayOfWeek.rawValue, for: dayTextfield).enumerated()), id: \.offset) { index, content in
                VStack {
                    Text(WeekDay.sortedWeekDays(startOn: startDayOfWeek)[index])
                        .foregroundStyle(.secondary)
                    content
                        .frame(width: 47)
                }
            }
        }

    }

    func sortedRotaTextfields(day: Int, for rotaTextFields: [DayTextField]) -> [DayTextField] {
        var newRotaTextFields = [DayTextField]()
        guard day != 0 else { return rotaTextFields }
        for i in 0..<rotaTextFields.count {
            if i + day < rotaTextFields.count {
                newRotaTextFields.append(rotaTextFields[i + day])
            } else {
                newRotaTextFields.append(rotaTextFields[i - (7 - day)])
            }
        }
        return newRotaTextFields
    }
}

#Preview {
    RotaTextField(
        dayTextfield: [DayTextField(title: "Sun", text: .constant("")), DayTextField(title: "Mon", text: .constant(""))],
        sunRota: .constant("701"),
        monRota: .constant("701"),
        tueRota: .constant("701"),
        wedRota: .constant("701"),
        thuRota: .constant("701"),
        friRota: .constant("701"),
        satRota: .constant("701")
    )
}
