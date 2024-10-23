//
//  SetUpView.swift
//  DutyRota
//
//  Created by Nigel Gee on 23/02/2024.
//

import SwiftUI

struct SetUpView: View {
    let setUp: [SetUp] = Bundle.main.decode(from: "setup.json")

    var body: some View {
        List {
            NavigationLink(destination: RotaStartView()) {
                Text("How to set up the a Rota information.")
            }

            NavigationLink(destination: DutyStartView()) {
                Text("How to set up the Duties information.")
            }
            ForEach(setUp) { value in
                HStack(alignment: .top, spacing: 20) {
                    Text(value.id)
                    Text(value.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationTitle("How to Set up your Duty Calendar")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)

    }
}

#Preview {
    NavigationStack {
        SetUpView()
    }
}
