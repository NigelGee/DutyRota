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
    let background: Color

    init(text: String, color: Color = .primary, background: Color = .clear) {
        self.text = text
        self.color = color
        self.background = background
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1)
            .foregroundStyle(.secondary.opacity(0.4))
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .background(background)
            .clipShape(.rect(cornerRadius: 5))
            .overlay {
                if background == .clear {
                    Text(text)
                        .dynamicTypeSize(...DynamicTypeSize.medium)
                        .foregroundStyle(color)
                } else {
                    Text(text)
                        .dynamicTypeSize(...DynamicTypeSize.medium)
                        .textTint(bgColorOf: background)
                }

            }
    }
}

#Preview {
    GridFrameView(text: "Mon")
}
