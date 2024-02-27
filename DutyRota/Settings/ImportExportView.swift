//
//  InstructionView.swift
//  DutyRota
//
//  Created by Nigel Gee on 17/02/2024.
//

import SwiftUI

struct ImportExportView: View {
    var body: some View {
        VStack {
            Text("Export")
                .font(.title)
            HStack {
                VStack(alignment: .leading) {
                    Text("1. Tap on \(Image(systemName: "tray"))")
                    Text("2. Tap on 'Export \(Image(systemName: "tray.and.arrow.up"))'")
                    Text("3. File will be saved to File App")
                    Text("4. Either a 'Rota' or 'Duty' name")
                    Text("5. Send to recipient (e-mail, or Air Drop).")
                }
                Spacer()
            }
            .padding()
            Divider()

            Text("Import")
                .font(.title)

            HStack {
                VStack(alignment: .leading) {
                    Text("1. Tap on \(Image(systemName: "tray"))")
                    Text("2. Select file to import where you saved it.")
                    Text("3. **Important**")
                    Text("Use save file for duty to Duty and file for rota to Rota.\n **Import files must be in the same days as the app days. Check that the first day on import file is the same as app day!")
                }
                Spacer()
            }
            .padding()
            Spacer()
            Text("Check out [www.theappforest.co.uk](https://www.theappforest.co.uk) for more detail description and diagrams.")
                .padding(.horizontal)

        }
        .navigationTitle("How To Import/Export files")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ImportExportView()
}
