//
//  ButtonView.swift
//  DutyRota
//
//  Created by Nigel Gee on 28/01/2024.
//

import SwiftUI

struct ButtonView: View {
    @Binding var selectedDate: Date

    var body: some View {
        HStack(spacing: 50) {
            Button {
                withAnimation {
                    changeMonth(by: -1)
                }
            } label: {
                Image(systemName: "lessthan")

            }
            .frame(width: 42, height: 42)

            Button {
                selectedDate = .now
            } label: {
                Text(selectedDate, format: .dateTime.month().year())
            }
            .foregroundStyle(.primary)

            Button {
                withAnimation {
                    changeMonth(by: 1)
                }
            } label: {
                Image(systemName: "greaterthan")
            }
            .frame(width: 42, height: 42)
        }
    }

    func changeMonth(by amount: Int) {
        let calendar = Calendar.current
        let newDate = selectedDate.startDateOfMonth

        selectedDate = calendar.date(byAdding: .month, value: amount, to: newDate)!

        if selectedDate.isDateInRange(start: .now.startDateOfMonth, end: .now.endDateOfMonth) {
            selectedDate = .now
        }
    }
}

#Preview {
    ButtonView(selectedDate: .constant(.now))
}
