//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI

struct DutyDetailView: View {
    var duty: Duty
    var body: some View {
        List {
            ForEach(duty.dutyDetails) { dutyDetail in
                Text(dutyDetail.title)
            }
        }
    }
}

//#Preview {
//    DutyDetailView()
//}
