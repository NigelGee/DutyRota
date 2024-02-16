//
//  DayTextField.swift
//  DutyRota
//
//  Created by Nigel Gee on 15/02/2024.
//

import SwiftUI

struct DayTextField: View, Identifiable {
    var id = UIView()
    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(title, text: $text)
                .font(.system(size: 15))
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(width: 45)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DayTextField(title: "Monday", text: .constant("Spare"))
}
