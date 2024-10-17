//
//  DayRotaView.swift
//  DutyRota
//
//  Created by Nigel Gee on 16/02/2024.
//

import SwiftUI

struct DayRotaView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.saturday
    var rotaDetail: RotaDetail
    let fontSize = 13.0
    let frameWidth = 35.0

    var body: some View {
        HStack {
            switch startDayOfWeek {
            case .sunday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                }
            case .monday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                }
            case .tuesday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                }
            case .wedneday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                }
            case .thursday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                }
            case .friday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.fri)
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                }
            case .saturday:
                Group {
                    GridFrameView(text: rotaDetail.line.formatted(.number))
                    GridFrameView(text: rotaDetail.sat)
                    GridFrameView(text: rotaDetail.sun)
                    GridFrameView(text: rotaDetail.mon)
                    GridFrameView(text: rotaDetail.tue)
                    GridFrameView(text: rotaDetail.wed)
                    GridFrameView(text: rotaDetail.thu)
                    GridFrameView(text: rotaDetail.fri)
                        
                }
            }

        }

    }
}

#Preview {
    DayRotaView(rotaDetail: RotaDetail(line: 999, sun: "8888", mon: "8888", tue: "8888", wed: "8888", thu: "8888", fri: "8888", sat: "8888"))
}
