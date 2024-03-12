//
//  AStack.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/03/2024.
//

import SwiftUI

struct AStack<Content: View>: View {
    private var spacing: CGFloat?
    private var hAlignment: HorizontalAlignment
    private var vAlignment: VerticalAlignment
    private var content: Content

    init(spacing: CGFloat? = nil, vAlignment: VerticalAlignment = .center ,hAlignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.hAlignment = hAlignment
        self.vAlignment = vAlignment
        self.content = content()
    }

    var body: some View {
        ViewThatFits {
            HStack(alignment: vAlignment, spacing: spacing) { content }
            VStack(alignment: hAlignment, spacing: spacing) { content }
        }
    }
}

#Preview {
    AStack() { Text("Test") }
}
