//
//  DayRotaView.swift
//  DutyRota
//
//  Created by Nigel Gee on 16/02/2024.
//

import SwiftUI

struct DayRotaView: View {
    @AppStorage("startOFWeek") var startDayOfWeek = WeekDay.sunday
    var rotaDetail: RotaDetail

    var body: some View {
        HStack {
            switch startDayOfWeek {
            case .sunday:
                Group {
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                }
            case .monday:
                Group {
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                }
            case .tuesday:
                Group {
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                }
            case .wedneday:
                Group {
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                }
            case .thursday:
                Group {
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                }
            case .friday:
                Group {
                    Text(rotaDetail.fri)
                    Spacer()
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                }
            case .saturday:
                Group {
                    Text(rotaDetail.sat)
                    Spacer()
                    Text(rotaDetail.sun)
                    Spacer()
                    Text(rotaDetail.mon)
                    Spacer()
                    Text(rotaDetail.tue)
                    Spacer()
                    Text(rotaDetail.wed)
                    Spacer()
                    Text(rotaDetail.thu)
                    Spacer()
                    Text(rotaDetail.fri)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DayRotaView(rotaDetail: RotaDetail(line: 999, sun: "8888", mon: "8888", tue: "8888", wed: "8888", thu: "8888", fri: "8888", sat: "8888"))
}
