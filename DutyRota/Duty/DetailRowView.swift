//
//  DetailRowView.swift
//  DutyRota
//
//  Created by Nigel Gee on 19/10/2024.
//

import SwiftUI

/// A view that shows a grid row for a duty details.
struct DetailRowView: View {

    /// A passed in `DutyDetail`.
    let dutyDetail: DutyDetail
    
    var body: some View {
        HStack {
            GridFrameView(text: dutyDetail.title, background: Color(dutyDetail.color))
            GridFrameView(text: dutyDetail.start.formattedTime, background: Color(dutyDetail.color))
            GridFrameView(text: dutyDetail.end.formattedTime, background: Color(dutyDetail.color))
            GridFrameView(text: dutyDetail.dutyBreakTime, background: Color(dutyDetail.color))
            GridFrameView(text: dutyDetail.tod.formattedTime, background: Color(dutyDetail.color))
            GridFrameView(text: dutyDetail.dutySpread, background: Color(dutyDetail.color))
        }
    }
}

#Preview {
    DetailRowView(dutyDetail: DutyDetail(title: "701", start: .now, end: .now, tod: .now, color: "dutyBlue"))
}
