//
//  IsPresentedModifier.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/11/2024.
//

import SwiftUI

struct IsPresented: ViewModifier {
    var isPresent: Bool

    func body(content: Content) -> some View {
        if isPresent {
            content
        } else {
            content
                .hidden()
        }
    }
}

extension View {
    func isPresented(for present: Bool) -> some View {
        modifier(IsPresented(isPresent: present))
    }
}
