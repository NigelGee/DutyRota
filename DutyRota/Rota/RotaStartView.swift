//
//  RotaStartView.swift
//  DutyRota
//
//  Created by Nigel Gee on 21/10/2024.
//

import SwiftUI

struct RotaStartView: View {
    var body: some View {
        ScrollView {
            Text("Set Up")
                .font(.title)
                .underline()
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("1. Set the first day of week in Setting tab.")
                Text("(This cannot be change once the rota has been set up.)")
                    .font(.footnote)
                    .padding(.top, -10)
                Image(.settingsScreen)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 2000)
                Text("2. Tap the \(Image(systemName: "plus")) button.")
                Image(.addRota)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 130)
                Text("3. Amended the date.")
                Image(.rotaDates)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 210)
                Text("4. Tap the Rota period line.")
                NavigationLink(destination: RotaDetailStartView()) {
                    Text("5. Set up details.")
                }
            }
            .padding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
        .bold()
    }
}

#Preview {
    NavigationStack {
        RotaStartView()
    }
}
