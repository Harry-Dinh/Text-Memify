//
//  TMSettingsView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-01-31.
//

import SwiftUI

struct TMSettingsView: View {
    
    @State private var viewModel = TMViewModel.instance
    
    var body: some View {
        Form {
            Picker("Default Meme Option:", selection: $viewModel.selectedOption) {
                Text("w i d e").tag(0)
                Text("W I D E").tag(1)
                Text("(desreveR) Reversed").tag(2)
                Text("Up AnD dOwN").tag(3)
            }
            .onChange(of: viewModel.selectedOption) {
                // Save the default meme option
                viewModel.saveDefaultMemeOption(viewModel.selectedOption)
            }
        }
        .frame(width: TMConstants.SETTINGS_PANE_WIDTH)
        .padding()
    }
}

#Preview {
    TMSettingsView()
}
