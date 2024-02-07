//
//  PreviewContainer.swift
//  DutyRota
//
//  Created by Nigel Gee on 06/02/2024.
//

import SwiftData

struct PreviewContainer {
    let container: ModelContainer

    init(_ models: any PersistentModel.Type...) {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema(models)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container!")
        }
    }

    func addExamples(of examples: [any PersistentModel]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
