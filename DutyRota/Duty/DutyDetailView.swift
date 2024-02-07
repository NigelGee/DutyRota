//
//  DutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 05/02/2024.
//

import SwiftUI

struct DutyDetailView: View {
    @Environment(\.modelContext) var modelContext
    let header = ["Num","On", "Off", "TOD", "Brk" ,"Spd"]
    var duty: Duty

    var navigationTitle: String {
        let start = "\(duty.periodStart.formatted(date: .numeric, time: .omitted))"
        var end = ""
        if duty.periodEnd == .distantFuture {
            end = "End"
        } else {
            end = "\(duty.periodEnd.formatted(date: .numeric, time: .omitted))"
        }
        return start + " - " + end
    }

    func dateFormatted(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }

    var body: some View {
        List {
            HStack {
                ForEach(header, id: \.self) {
                    Text($0)
                        .frame(maxWidth: .infinity)
                }
            }
            
            if duty.dutyDetails.isNotEmpty {
                Grid {
                    ForEach(duty.dutyDetails.sorted()) { dutyDetail in
                        GridRow {
                            HStack {
                                Text(dutyDetail.title)
                                Spacer()
                                Text(dateFormatted(for:dutyDetail.start))
                                Spacer()
                                Text(dateFormatted(for:dutyDetail.end))
                                Spacer()
                                Text(dutyDetail.tod.formatted(date: .omitted, time: .shortened))
                                Spacer()
                                Text(dutyDetail.dutyBreakTime)
                                Spacer()
                                Text(dutyDetail.dutySpread)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 5)
                        }
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .toolbar {
            Button(action: addSample) {
                Label("Add Sample", systemImage: "plus")
            }

            Button(action: deleteAll) {
                Label("Add Sample", systemImage: "trash")
            }
        }
        .onAppear(perform: onAppearDefault)
    }

    func deleteAll() {
        duty.dutyDetails.removeAll()
    }

    func onAppearDefault() {
        guard duty.dutyDetails.isEmpty else { return }
        var components = DateComponents()
        var restStart: Date {
            components.hour = 0
            components.minute = 0
            return Calendar.current.date(from: components)!
        }

        var restEnd: Date {
            components.hour = 23
            components.minute = 59
            return Calendar.current.date(from: components)!
        }

        let restDetail = DutyDetail(title: "Rest", start: restStart, end: restEnd, tod: restStart)
        duty.dutyDetails.append(restDetail)
    }

    func addSample() {
        var todTime: Date {
            var components = DateComponents()
            components.hour = 2
            components.minute = 0
            return Calendar.current.date(from: components)!
        }

        let dutyDetail = DutyDetail(title: "101", start: .now, end: .now.addingTimeInterval(10800), tod: todTime)
        duty.dutyDetails.append(dutyDetail)
    }
}

//#Preview {
//    let preview = PreviewContainer(DutyDetail.self)
//    preview.addExamples(of: Duty.sampleDuties)
//    return DutyDetailView(duty: Duty.sampleDuties[0])
//        .modelContainer(preview.container)
//}
