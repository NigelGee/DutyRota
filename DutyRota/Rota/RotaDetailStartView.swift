//
//  RotaDetailStartView.swift
//  DutyRota
//
//  Created by Nigel Gee on 21/10/2024.
//

import SwiftUI

struct RotaDetailStartView: View {
    var body: some View {
        ScrollView {
            Text("Set Up")
                .font(.title)
                .underline()
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("You can entering the the details manually by tapping the \(Image(systemName: "plus")) button or by importing a CSV file by tapping the \(Image(systemName: "tray")) button")
                Image(.addRotaDetails)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
                Text("Enter Manual Details")
                    .font(.title3)
                    .underline()
                Text("1. Enter rota line and duties for each day of week and tap \"Add\" button.")
                HStack {
                    Spacer()
                    GroupBox {
                        Image(.enterRotaDetails)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    }
                    Spacer()
                }
                Text("2. Repeat until all Rota lines are added.")
                Text("3. Add the first line of rota for the period.")
                Image(.enterFirstLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)

                Text("Import Rota Details")
                    .font(.title3)
                    .underline()
                Text("1. You can make a CSV file by using MS Excel by using headers of *Line, (Days of Week start on the first day of your choose)* then just add lines of rota to it.")
                Text("2. This can also be export from an user's Rotas to be imported into this app.")
                Text("3. Tap the \(Image(systemName: "tray")) button and select \"Import\".")
                Text("4. Select the CSV file to import.")
                Text("5. Add the first line of rota for the period.")
                Image(.enterFirstLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 150)

            }
            .padding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
        .bold()
    }
}

#Preview {
    RotaDetailStartView()
}
