//
//  DayAdHocDutiesRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 04/03/2024.
//

import SwiftUI

/// A view that show a Ad Hoc duty if it an overtime duty.
struct DayAdHocDutiesRowView: View {

    /// A passed in property of `AdHocDuty`.
    let duty: AdHocDuty
    
    /// A method that act on selected duty.
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 5) {
                Text(duty.title)
                    .bold()
                Spacer()

                AStack {
                    Text(duty.start, format: .dateTime.hour().minute())
                        .bold()
                    Text(duty.end, format: .dateTime.hour().minute())
                }
            }
            .font(.system(size: 12))
            .padding(5)
            .background(.dutyAdHoc)
            .textTint(bgColorOf: Color(.dutyAdHoc))
            .clipShape(.rect(cornerRadius: 5))
        }
        .buttonStyle(.plain)
        .hoverEffect()
    }
}

#Preview {
    DayAdHocDutiesRowView(duty: .init(title: "", route: "", start: .zeroTime, end: .zeroTime, breakTime: .zeroTime)) { }
}
