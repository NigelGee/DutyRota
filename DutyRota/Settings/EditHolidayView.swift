//
//  EditHolidayView.swift
//  DutyRota
//
//  Created by Nigel Gee on 24/02/2024.
//

import SwiftUI

struct EditHolidayView: View {
    @Bindable var holiday: Holiday

    var body: some View {
        Form {
            DatePicker("Start Of Holiday", selection: $holiday.start, displayedComponents: .date)
            DatePicker("End Of Holiday", selection: $holiday.end, displayedComponents: .date)
        }
    }
}

#Preview {
    EditHolidayView(holiday: Holiday(start: .now, end: .now))
}
