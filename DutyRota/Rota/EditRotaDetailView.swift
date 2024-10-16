//
//  EditRotaDetailView.swift
//  DutyRota
//
//  Created by Nigel Gee on 17/02/2024.
//

import SwiftUI

struct EditRotaDetailView: View {
    @Bindable var rotaDetail: RotaDetail
    var body: some View {
        let dayTextfieldViews = [
            DayTextField(title: "Sun", text: $rotaDetail.sun),
            DayTextField(title: "Mon", text: $rotaDetail.mon),
            DayTextField(title: "Tue", text: $rotaDetail.tue),
            DayTextField(title: "Wed", text: $rotaDetail.wed),
            DayTextField(title: "Thu", text: $rotaDetail.thu),
            DayTextField(title: "Fri", text: $rotaDetail.fri),
            DayTextField(title: "Sat", text: $rotaDetail.sat)
        ]

        VStack {
            LabeledContent("Rota Line:") {
                TextField("Line", value: $rotaDetail.line, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            .padding(.vertical)

            Divider()

            RotaTextField(dayTextfield: dayTextfieldViews,
                          sunRota: $rotaDetail.sun,
                          monRota: $rotaDetail.mon,
                          tueRota: $rotaDetail.tue,
                          wedRota: $rotaDetail.wed,
                          thuRota: $rotaDetail.thu,
                          friRota: $rotaDetail.fri,
                          satRota: $rotaDetail.sat
            )

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Add New Rota Lines")
        .navigationBarTitleDisplayMode(.inline)

    }
}

//#Preview {
//    EditRotaDetailView(rotaDetail: .)
//}
