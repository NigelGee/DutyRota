//
//  SwipeActionTip.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/11/2024.
//

import Foundation
import TipKit

struct SwipeActionTip: Tip {
    @Parameter
    static var thresholdParameter: Bool = false

    var options: [TipOption] {
        Tips.MaxDisplayCount(1)
    }

    var title: Text {
        Text("Swipe to Edit/Delete")
            .font(.title3)
            .bold()
    }

    var message: Text? {
        Text("""
            Swipe to the right to change the date period.
            
            Swipe to the left to delete the period.
            
            Warning: Deleting a date period will delete any data that associated with it. 
            """)
    }

    var rules: [Rule] {
        #Rule(Self.$thresholdParameter) { $0 == true }
    }
}
