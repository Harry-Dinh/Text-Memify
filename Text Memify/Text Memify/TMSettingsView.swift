//
//  TMSettingsView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-01-31.
//

import SwiftUI

struct TMSettingsView: View {
    
    @State private var viewModel = TMViewModel.instance
    @State private var defaultMemeOption = TMViewModel.instance.selectedOption
    
    var body: some View {
        Form {
            Picker("Default Meme Option:", selection: $defaultMemeOption) {
                Text("w i d e").tag(0)
                Text("W I D E").tag(1)
                Text("(desreveR) Reversed").tag(2)
                Text("Up AnD dOwN").tag(3)
            }
            .onChange(of: defaultMemeOption) {
                // Save the default meme option
                viewModel.saveDefaultMemeOption(defaultMemeOption)
            }
            
            Section {
                Toggle(isOn: $viewModel.storeDuplicates) {
                    VStack(alignment: .leading) {
                        Text("Store duplicate entries")
                        Text("When turned on, Text Memify will store entries that have the same original and result text. Original text with different result will still always be stored.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(width: TMConstants.SETTINGS_PANE_WIDTH)
        .padding()
    }
}

#Preview {
    TMSettingsView()
}
