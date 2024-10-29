//
//  Array - Replace.swift
//  DutyRota
//
//  Created by Nigel Gee on 29/10/2024.
//

import Foundation

extension Array {
    mutating
    func replaceElement(before index: Index) {
        self.remove(at: index)
        self.insert(self[index - 1], at: index)
    }

    mutating
    func replaceElement(after index: Index) {
        self.insert(self[index + 1], at: index)
        self.remove(at: index + 1)
    }

    mutating
    func replaceElement(at index: Index, with element: Element) {
        self.remove(at: index)
        self.insert(element, at: index)
    }
}
