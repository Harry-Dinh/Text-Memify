//
//  ContentView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2024-12-06.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = TMViewModel.instance
    @Environment(\.openWindow) private var openWindow
    
    // MARK: - Main Body
    
    var body: some View {
        VStack {
            Form {
                originalTextField
                memeModeSelectorSection
                resultTextField
                copyToClipboardToggle
            }
            .textFieldStyle(.roundedBorder)
            .padding()

            actionButtonsSection
        }
        .padding()
        .frame(minWidth: TMConstants.MAIN_VIEW_DIMENSION, maxWidth: TMConstants.MAIN_VIEW_DIMENSION)
    }

    // MARK: - Subviews

    private var originalTextField: some View {
        TextField("label_text", text: $viewModel.originalText)
            .accessibilityLabel(Text("label_text"))
            .accessibilityIdentifier("originalTextField")
    }

    private var memeModeSelector: some View {
        Picker(selection: $viewModel.selectedOption) {
            Text("format_wide_lowercased").tag(TMMemeFormats.wideLowercased)
            Text("format_wide_uppercased").tag(TMMemeFormats.wideUppercased)
            Text("format_reversed").tag(TMMemeFormats.reversed)
            Text("format_up_and_down").tag(TMMemeFormats.upAndDown)
        } label: {
            Text("label_meme_format")
        }
        .accessibilityLabel(Text("label_meme_format"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("memeModeSelector")
    }

    private var resultTextField: some View {
        TextField("label_result", text: $viewModel.resultText)
            .accessibilityLabel(Text("label_result"))
            .accessibilityIdentifier("resultTextField")
    }

    private var actionButtonsSection: some View {
        HStack {
            showHistoryButton
            Spacer()
            clearButton
            memifyButton
        }
    }

    private var showHistoryButton: some View {
        Button("label_show_history") {
            openWindow.callAsFunction(id: TMConstants.HISTORY_WINDOW_ID)
        }
        .accessibilityLabel(Text("label_show_history"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("showHistoryButton")
    }

    private var clearButton: some View {
        Button("label_clear") {
            viewModel.clearFields()
        }
        .accessibilityLabel(Text("label_clear"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("clearButton")
    }

    private var memifyButton: some View {
        Button("label_memify") {
            viewModel.memify()                  // Memify the original text
            viewModel.saveToHistory()           // Save entry to history
            if viewModel.shouldCopyToClipboard {
                viewModel.copyToClipboard()     // Copy result text to clipboard
            }
        }
        .keyboardShortcut(.defaultAction)
        .disabled(viewModel.originalText.isEmpty)
        .accessibilityLabel(Text("label_memify"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("memifyButton")
    }
    
    private var copyToClipboardToggle: some View {
        Toggle(isOn: $viewModel.shouldCopyToClipboard) {
            Text("label_copy_to_clipboard")
        }
        .accessibilityLabel(Text("label_copy_to_clipboard"))
        .accessibilityAddTraits(.isToggle)
        .accessibilityIdentifier("copyToClipboardToggle")
    }
    
    @ViewBuilder
    private var memeModeSelectorSection: some View {
        if viewModel.selectedOption == .upAndDown {
            HStack {
                memeModeSelector
                formatOptionButton
            }
        } else {
            memeModeSelector
        }
    }
    
    private var formatOptionButton: some View {
        Button(action: {
            viewModel.showFormatOptionPopover.toggle()
        }) {
            Image(systemName: "ellipsis")
                .symbolVariant(.circle)
                .accessibilityRemoveTraits(.isImage)
                .accessibilityElement(children: .ignore)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $viewModel.showFormatOptionPopover) {
            FormatOptionView(viewModel)
        }
        .accessibilityLabel(Text("label_format_option"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("formatOptionButton")
    }
}

#Preview {
    ContentView()
}
