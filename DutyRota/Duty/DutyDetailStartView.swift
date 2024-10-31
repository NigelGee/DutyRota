//
//  DutyDetailStartView.swift
//  DutyRota
//
//  Created by Nigel Gee on 22/10/2024.
//

import SwiftUI

struct DutyDetailStartView: View {
    var body: some View {
        ScrollView {
            Text("Set Up")
                .font(.title)
                .underline()
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("You can entering the the details manually by tapping the \(Image(systemName: "plus")) button or by importing a CSV file by tapping the \(Image(systemName: "tray")) button")
                Image(.addDutyDetails)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
                Text("Enter Manual Details")
                    .font(.title3)
                    .underline()
                Text("1. Enter duty details with Sign on/off and the hours of the duty (without breaks). The app will work out the break times and total spread of duty. You can also change the Duty Colour by tapping the colour.")
                Image(.enterDutyDetails)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 260)
                Text("2. Repeat until all Duties are added.")

                Text("Import Duty Details")
                    .font(.title3)
                    .underline()
                Text("1. You can make a CSV file by using MS Excel by using headers of *Duty, SignOn, SignOff, ToD* then just add lines of duties to it.")
                Text("2. This can also be export from an user's Duties to be imported into this app.")
                Text("3. Tap the \(Image(systemName: "tray")) button and select \"Import\".")
                Text("4. Select the CSV file to import.")
            }
            .padding(.horizontal)
        }
        .scrollBounceBehavior(.basedOnSize)
        .bold()
    }
}

#Preview {
    DutyDetailStartView()
}
