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
        HStack {
            Form {
                Group {
                    memeOptionPicker
                    storeDuplicatesToggle
                    alwaysCopyToClipboardToggle
                }
                .padding(.vertical, 3)
            }
            .frame(width: TMConstants.SETTINGS_PANE_WIDTH)
            .padding()
        }
    }
    
    private var alwaysCopyToClipboardToggle: some View {
        Toggle(isOn: $viewModel.copyToClipboardSettings) {
            Text("Always copy to clipboard")
        }
        .onChange(of: viewModel.copyToClipboardSettings) { _, updatedValue in
            UserDefaults.standard.set(updatedValue, forKey: "copyToClipboardSettings")
        }
    }
    
    private var memeOptionPicker: some View {
        Picker("Default Format:", selection: $defaultMemeOption) {
            Text("w i d e").tag(0)
            Text("W I D E").tag(1)
            Text("(desreveR) Reversed").tag(2)
            Text("Up AnD dOwN").tag(3)
        }
        .padding(.vertical, 5)
        .onChange(of: defaultMemeOption) {
            // Save the default meme option
            viewModel.saveDefaultMemeOption(defaultMemeOption)
        }
    }
    
    private var storeDuplicatesToggle: some View {
        Toggle(isOn: $viewModel.storeDuplicates) {
            VStack(alignment: .leading) {
                Text("Store duplicate entries")
                Text("When enabled, Text Memify will store entries that have the same original and result text. Original text with different result will still always be stored.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TMSettingsView()
}
