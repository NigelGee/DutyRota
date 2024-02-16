//
//  AddRotaDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 15/02/2024.
//

import SwiftUI

struct AddRotaDetailView: View {
    @Bindable var rota: Rota
    @State private var lineRota: Int?
    @State private var sunRota = ""
    @State private var monRota = ""
    @State private var tueRota = ""
    @State private var wedRota = ""
    @State private var thuRota = ""
    @State private var friRota = ""
    @State private var satRota = ""

    @State private var showAddRotaAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        let dayTextfieldViews = [
            DayTextField(title: "Sun", text: $sunRota),
            DayTextField(title: "Mon", text: $monRota),
            DayTextField(title: "Tue", text: $tueRota),
            DayTextField(title: "Wed", text: $wedRota),
            DayTextField(title: "Thu", text: $thuRota),
            DayTextField(title: "Fri", text: $friRota),
            DayTextField(title: "Sat", text: $satRota)
        ]
        NavigationStack {
            VStack {
                LabeledContent("Rota Line:") {
                    TextField("Line", value: $lineRota, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                }
                .padding(.vertical)

                Divider()

                RotaTextField(dayTextfield: dayTextfieldViews,
                              sunRota: $sunRota,
                              monRota: $monRota,
                              tueRota: $tueRota,
                              wedRota: $wedRota,
                              thuRota: $thuRota,
                              friRota: $friRota,
                              satRota: $satRota
                )

                Divider()

                Button("Add") {
                    addNewRota()
                }
                .buttonStyle(.bordered)
                .disabled(lineRota == nil)
                .padding()
                Spacer()
            }
            .navigationTitle("Add New Rota Lines")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .alert(alertTitle, isPresented: $showAddRotaAlert) {
                Button("Ok") { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    func addNewRota() {
        guard let lineRota else { return }
        guard !rota.rotaDetails.contains (where: { $0.line == lineRota }) else {
            self.lineRota = nil
            alertTitle = "ERROR!"
            alertMessage = "This rota line already exists."
            showAddRotaAlert = true
            return
        }
        let rotaDetail = RotaDetail(line: lineRota, sun: sunRota, mon: monRota, tue: tueRota, wed: wedRota, thu: thuRota, fri: friRota, sat: satRota)
        rota.rotaDetails.append(rotaDetail)
        self.lineRota = nil
        sunRota = ""
        monRota = ""
        tueRota = ""
        wedRota = ""
        thuRota = ""
        friRota = ""
        satRota = ""
        alertTitle = "Added!"
        alertMessage = ""
        showAddRotaAlert = true
    }

    
}

#Preview {
    AddRotaDetailView(rota: Rota.example)
}
