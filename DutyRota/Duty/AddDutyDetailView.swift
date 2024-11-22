//
//  EditDutyDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 08/02/2024.
//

import SwiftUI

struct AddDutyDetailView: View {
    @Bindable var duty: Duty

    @State private var title = ""
    @State private var start = Date.zeroTime
    @State private var end = Date.zeroTime
    @State private var tod = Date.zeroTime
    @State private var notes: String = ""
    @State private var showAlert = false
    @State private var selectedColor: String
    @State private var showColorPicker = false

    init(duty: Duty, selectedColor: String) {
        self.duty = duty
        _selectedColor = State(wrappedValue: selectedColor)
    }

    var body: some View {
        NavigationStack {
            VStack {
                LabeledContent("Duty:") {
                    TextField("Duty", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 71)
                }

                DatePicker("Sign On:", selection: $start, displayedComponents: .hourAndMinute)
                DatePicker("Sign Off:", selection: $end, displayedComponents: .hourAndMinute)
                DatePicker("Time On Duty:", selection: $tod, displayedComponents: .hourAndMinute)

                HStack {
                    Text("Duty Colour:")
                    Spacer()
                    Button {
                        showColorPicker = true
                    } label: {
                        Color(selectedColor)
                            .frame(width: 71, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 7)
                            .strokeBorder(.primary, lineWidth: 1)
                    }
                }

                VStack(alignment: .leading) {
                    TextField("Notes:", text: $notes, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                    Text("Notes that added to duties will not be exported.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Button("Add", action: addDuty)
                    .buttonStyle(.borderedProminent)
                    .disabled(title.isEmpty)

                Divider()

                #warning(#"remove \.self from id when in production"#)
                List(duty.unwrappedDutyDetails.sorted(), id: \.self) { dutyDetail in
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
            .sheet(isPresented: $showColorPicker) {
                ColorPickerView(selectedColor: $selectedColor)
                    .presentationDetents([.height(250)])
            }
        }
    }

    func addDuty() {
        guard !duty.unwrappedDutyDetails.map(\.title).contains(title) else {
            showAlert = true
            title = ""
            return
        }

        let newDuty = DutyDetail(title: title, start: start, end: end, tod: tod, color: selectedColor)
        duty.dutyDetails?.append(newDuty)
        
        title = ""
        start = Date.zeroTime
        end = Date.zeroTime
        tod = Date.zeroTime
    }
}

//#Preview {
//    let preview = PreviewContainer(Duty.self)
//    return AddDutyDetailView(duty: Duty.sampleDuties[0], selectedColor: "dutyGreen")
//        .modelContainer(preview.container)
//}
