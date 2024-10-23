//
//  DutyStartView.swift
//  DutyRota
//
//  Created by Nigel Gee on 22/10/2024.
//

import SwiftUI

struct DutyStartView: View {
    var body: some View {
        ScrollView {
            Text("Set Up")
                .font(.title)
                .underline()
                .padding()

            VStack(alignment: .leading, spacing: 10) {
                Text("1. Tap the \(Image(systemName: "plus")) button.")
                Image(.addDuty)
                    .resizable()
                    .frame(height: 130)
                Text("3. Amended the date.")
                Image(.dutyDates)
                    .resizable()
                    .frame(height: 210)
                Text("4. Tap the Duty period line.")
                NavigationLink(destination: DutyDetailStartView()) {
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
        DutyStartView()
    }
}
