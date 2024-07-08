//
//  TextTint-Modifier.swift
//  DutyRota
//
//  Created by Nigel Gee on 14/06/2024.
//

import SwiftUI

struct TextTint: ViewModifier {
    let color: Color

    var adjustedColor: Color {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        guard (red + green + blue) > 0 else { return .primary }

        let lightRed = red > 0.65
        let lightGreen = green > 0.65
        let lightBlue = blue > 0.65

        let luminance = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }

        return luminance >= 2 ? .black : .white
    }

    func body(content: Content) -> some View {
        content
            .foregroundStyle(adjustedColor)
    }
}

extension View {
    func textTint(bgColorOf color: Color) -> some View {
        modifier(TextTint(color: color))
    }
}
