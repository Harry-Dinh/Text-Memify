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
            Text("label_always_copy_to_clipboard")
        }
        .onChange(of: viewModel.copyToClipboardSettings) { _, updatedValue in
            UserDefaults.standard.set(updatedValue, forKey: "copyToClipboardSettings")
        }
        .accessibilityLabel(Text("label_always_copy_to_clipboard"))
        .accessibilityAddTraits(.isToggle)
        .accessibilityIdentifier("alwaysCopyToClipboardToggle")
    }
    
    private var memeOptionPicker: some View {
        Picker("label_default_format", selection: $defaultMemeOption) {
            Text("format_wide").tag(TMMemeFormats.wide)
            Text("format_reversed").tag(TMMemeFormats.reversed)
            Text("format_up_and_down").tag(TMMemeFormats.upAndDown)
        }
        .padding(.vertical, 5)
        .onChange(of: defaultMemeOption) {
            // Save the default meme option
            viewModel.saveDefaultMemeOption(defaultMemeOption)
        }
        .accessibilityLabel(Text("label_default_format"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("memeFormatPicker")
    }
    
    private var storeDuplicatesToggle: some View {
        Toggle(isOn: $viewModel.storeDuplicates) {
            VStack(alignment: .leading) {
                Text("label_store_duplicate_entries")
                Text("store_duplicate_entries_description")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityLabel(Text("label_store_duplicate_entries"))
        .accessibilityAddTraits(.isToggle)
        .accessibilityIdentifier("storeDuplicateEntriesToggle")
    }
}

#Preview {
    TMSettingsView()
}
