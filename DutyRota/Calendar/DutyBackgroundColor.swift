//
//  DutyBackgroundColor.swift
//  DutyRota
//
//  Created by Nigel Gee on 12/02/2024.
//

import SwiftUI

struct DutyBackground: View {
    let color: String
    let isValid: Bool

    init(for color: String, when isValid: Bool) {
        self.color = color
        self.isValid = isValid
    }
    var body: some View {
        if isValid {
            Color(color)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

#Preview {
    DutyBackground(for: "dutyBlue", when: true)
}
