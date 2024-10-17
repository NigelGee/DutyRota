//
//  GridFrameView.swift
//  DutyRota
//
//  Created by Nigel Gee on 16/10/2024.
//

import SwiftUI

struct GridFrameView: View {
    let text: String
    let color: Color

    init(text: String, color: Color = .primary) {
        self.text = text
        self.color = color
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1)
            .foregroundStyle(.secondary.opacity(0.4))
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .overlay {
                Text(text)
                    .dynamicTypeSize(...DynamicTypeSize.medium)
                    .foregroundColor(color)
            }
    }
}

#Preview {
    GridFrameView(text: "Mon")
}
