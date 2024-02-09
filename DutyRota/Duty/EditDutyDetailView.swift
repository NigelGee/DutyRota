//
//  EditDutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 08/02/2024.
//

import SwiftUI

struct EditDutyDetailView: View {
    @Bindable var duty: Duty

    @State private var title = ""
    @State private var start = Date.zeroTime
    @State private var end = Date.zeroTime
    @State private var tod = Date.zeroTime
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                LabeledContent("Duty:") {
                    TextField("Duty", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 70)
                }

                DatePicker("Sign On:", selection: $start, displayedComponents: .hourAndMinute)
                DatePicker("Sign Off:", selection: $end, displayedComponents: .hourAndMinute)
                DatePicker("Time On Duty:", selection: $tod, displayedComponents: .hourAndMinute)
                Button("Add", action: addDuty)
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty)

                Divider()
                
                List(duty.dutyDetails.sorted()) { dutyDetail in
                    HStack {
                        Text("**\(dutyDetail.title)**")
                        Spacer()
                        Text("Start: **\(dutyDetail.start.formattedTime)**")
                       
                        Text("Finish: **\(dutyDetail.end.formattedTime)**")
                    }
                    .multilineTextAlignment(.trailing)
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                }

                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Add New Duty")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error Duty Exist", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text("This duty already exist. Check to see if you want to delete existing duty or keep it.")
            }

        }
    }

    func addDuty() {
        guard !duty.dutyDetails.map(\.title).contains(title) else {
            showAlert = true
            title = ""
            return
        }

        let newDuty = DutyDetail(title: title, start: start, end: end, tod: tod)
        duty.dutyDetails.append(newDuty)
        
        title = ""
        start = Date.zeroTime
        end = Date.zeroTime
        tod = Date.zeroTime
    }
}

#Preview {
    let preview = PreviewContainer(Duty.self)
    return EditDutyDetailView(duty: Duty.sampleDuties[0])
        .modelContainer(preview.container)
}
