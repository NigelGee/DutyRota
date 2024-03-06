//
//  AStack.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/03/2024.
//

import SwiftUI

struct AStack<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ViewThatFits {
            HStack { content }
            VStack { content }
        }
    }
}

#Preview {
    AStack() { Text("Test") }
}
