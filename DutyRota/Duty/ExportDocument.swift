//
//  ExportDocument.swift
//  DutyRota
//
//  Created by Nigel Gee on 10/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }

    var payLoad: String

    init(payLoad: String) {
        self.payLoad = payLoad
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents, let string = String(data: data, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }

        payLoad = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: payLoad.data(using: .utf8)!)
    }
}
