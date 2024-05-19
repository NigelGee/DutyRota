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
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                }
            case .monday:
                Group {
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                }
            case .tuesday:
                Group {
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                }
            case .wedneday:
                Group {
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                }
            case .thursday:
                Group {
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                }
            case .friday:
                Group {
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                }
            case .saturday:
                Group {
                    Text(rotaDetail.sat)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                    Text(rotaDetail.sun)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.mon)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.tue)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.wed)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.thu)
                        .frame(maxWidth: .infinity)
                    Text(rotaDetail.fri)
                        .frame(maxWidth: .infinity)
                }
            }

        }

    }
}

#Preview {
    DayRotaView(rotaDetail: RotaDetail(line: 999, sun: "8888", mon: "8888", tue: "8888", wed: "8888", thu: "8888", fri: "8888", sat: "8888"))
}
