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
    let fontSize = 13.0
    let frameWidth = 35.0

    var body: some View {
        HStack {
            switch startDayOfWeek {
            case .sunday:
                Group {
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sat)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            case .monday:
                Group {
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sat)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            case .tuesday:
                Group {
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sat)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            case .wedneday:
                Group {
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sat)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            case .thursday:
                Group {
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sat)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            case .friday:
                Group {
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
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
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth, height: 30)
                    Text(rotaDetail.sun)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.mon)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.tue)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.wed)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.thu)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                    Text(rotaDetail.fri)
                        .font(.system(size: fontSize))
                        .frame(width: frameWidth)
                }
            }

        }

    }
}

#Preview {
    DayRotaView(rotaDetail: RotaDetail(line: 999, sun: "8888", mon: "8888", tue: "8888", wed: "8888", thu: "8888", fri: "8888", sat: "8888"))
}
