//
//  EventEditViewController.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/02/2024.
//

import EventKitUI
import SwiftUI

/// A View to show the native Event View Controller
///
/// This is not working as getting dealloc message and crashes on real devices.
/// Revisit if API changes.
struct EventEditViewController: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss

    var event: EKEvent?
    var eventStore: EKEventStore
    var loadEvent: () -> Void

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.eventStore = eventStore
        eventEditViewController.event = event
        eventEditViewController.editViewDelegate = context.coordinator
        return eventEditViewController
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) { }


    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController

        init(_ controller: EventEditViewController) {
            self.parent = controller
        }

        deinit {
            print("deinit \(self)")
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.loadEvent()
            parent.dismiss()
        }
    }
}
