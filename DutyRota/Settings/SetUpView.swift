//
//  SetUpView.swift
//  DutyRota
//
//  Created by Nigel Gee on 23/02/2024.
//

import SwiftUI

struct SetUpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("1. Allow 'Full Access' to your Calendar to show your calendar events in this calendar. If you do not want your personal calendars then do not allow but you will not be able to add or change them from the app!")
                Text("1a. To change ***Settings>Privacy Services>Calendars*** change to 'Full Access'")
            }
        }
        .padding()
        .navigationTitle("How to Set up your Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SetUpView()
    }
}
