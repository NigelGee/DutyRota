//
//  EditDutyDetailTip.swift
//  DutyRota
//
//  Created by Nigel Gee on 03/11/2024.
//

import Foundation
import TipKit

struct EditDutyDetailTip: Tip {
    @Parameter
    static var thresholdParameter: Bool = false

    var options: [TipOption] {
        Tips.MaxDisplayCount(2)
    }

    var title: Text {
        Text("Edit Duty Detail")
            .font(.title3)
            .bold()
    }

    var message: Text? {
        Text("Tap on a row that you want to edit the colour, start time, end time, or notes. You can also delete individual duty.")
    }

    var rules: [Rule] {
        #Rule(Self.$thresholdParameter) { $0 == true }
    }
}
