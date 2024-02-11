//
//  ColorPickerDisplayView.swift
//  DutyRota
//
//  Created by Nigel Gee on 11/02/2024.
//

import SwiftUI

struct ColorPickerDisplayView: View {
    let selectedColor: String

    var body: some View {
        HStack(spacing: 5) {
            VStack {
                Text(Date.now.add(day: -1).formatted(.dateTime.day()))
                    .foregroundStyle(.secondary)
                    .bold()
                Circle()
                    .frame(width: 5)
            }
            .frame(width: 37, height: 53)
            .background {
                Color(selectedColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            VStack {
                Text(Date.now.formatted(.dateTime.day()))
                    .padding(5)
                    .foregroundStyle(.red)
                    .bold()
                    .background {
                        Circle()
                            .stroke(lineWidth: 2)
                            .frame(width: 200)
                    }
                Circle()
                    .fill(.orange)
                    .frame(width: 5)
            }
            .frame(width: 37, height: 53)
            .background {
                Color(selectedColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }

            VStack {
                Text(Date.now.add(day: 1).formatted(.dateTime.day()))
                    .bold()

                HStack {
                    Circle()
                        .frame(width: 5)
                    Circle()
                        .fill(.orange)
                        .frame(width: 5)
                }
            }
            .frame(width: 37, height: 53)
            .background {
                Color(selectedColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
        .padding()
    }
}

#Preview {
    ColorPickerDisplayView(selectedColor: "dutyGreen")
}
