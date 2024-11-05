//
//  EditRotaDetailTip.swift
//  DutyRota
//
//  Created by Nigel Gee on 03/11/2024.
//

import Foundation
import TipKit

struct EditRotaDetailTip: Tip {
    @Parameter
    static var thresholdParameter: Bool = false

    var options: [TipOption] {
        Tips.MaxDisplayCount(2)
    }

    var title: Text {
        Text("Edit Rota Detail")
            .font(.title3)
            .bold()
    }

    var message: Text? {
        Text("Tap on a row that you want to edit a duty number.")
    }

    var rules: [Rule] {
        #Rule(Self.$thresholdParameter) { $0 == true }
    }
}
