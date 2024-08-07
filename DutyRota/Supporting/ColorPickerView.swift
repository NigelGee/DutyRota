//
//  ColorPickerView.swift
//  DutyRota
//
//  Created by Nigel Gee on 11/02/2024.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: String

    let colors = ["dutyClear",
                  "dutySilver",
                  "dutySourLemon",
                  "dutyLightYellow",
                  "dutyYellow",
                  "dutyGreen",
                  "dutyMintLeaf",
                  "dutyLightGreen",
                  "dutyGreenDarnerTail",
                  "dutyLightBlue",
                  "dutyBlue",
                  "dutyFirstDate",
                  "dutyPink",
                  "dutyPeach",
                  "dutyShyMoment",
                  "dutyPurple"
    ]

    var body: some View {
        VStack {
            Text("Select a Colour")
                .font(.headline)
            ColorPickerDisplayView(selectedColor: selectedColor)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 30, maximum: 30))]) {
                ForEach(colors, id:\.self) { color in
                    Color(color)
                        .frame(width: 30, height: 30)
                        .clipShape(.rect(cornerRadius: 5))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.primary, lineWidth: 1)
                            
                            if self.selectedColor == color {
                                Image(systemName: "checkmark")
                                    .bold()
                            }
                        }
                        .onTapGesture {
                            self.selectedColor = color
                        }
                }

                Spacer()
            }
            .frame(width: 300)
        }
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant("dutyGreen"))
}
