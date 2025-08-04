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
    
    var body: some View {
        VStack {
            Form {
                originalTextField
                memeModeSelector
                resultTextField
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
        TextField("Text:", text: $viewModel.originalText)
            .accessibilityIdentifier("originalTextField")
    }

    private var memeModeSelector: some View {
        Picker(selection: $viewModel.selectedOption) {
            Text("w i d e").tag(0)
            Text("W I D E").tag(1)
            Text("(desreveR) Reversed").tag(2)
            Text("Up AnD dOwN").tag(3)
        } label: {
            Text("Meme Format:")
        }
        .accessibilityIdentifier("memeModeSelector")
    }

    private var resultTextField: some View {
        TextField("Result:", text: $viewModel.resultText)
            .accessibilityIdentifier("resultTextField")
    }

    private var actionButtonsSection: some View {
        HStack {
            showHistoryButton
            Spacer()
            clearButton
            memeAndCopyToClipboardButton
        }
    }

    private var showHistoryButton: some View {
        Button("Show History") {
            openWindow.callAsFunction(id: TMConstants.HISTORY_WINDOW_ID)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("showHistoryButton")
    }

    private var clearButton: some View {
        Button("Clear") {
            viewModel.clearFields()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("clearButton")
    }

    private var memeAndCopyToClipboardButton: some View {
        Button("Meme and Copy to Clipboard") {
            viewModel.memify()              // Memify the original text
            viewModel.saveToHistory()       // Save entry to history
            viewModel.copyToClipboard()     // Copy result text to clipboard
        }
        .keyboardShortcut(.defaultAction)
        .disabled(viewModel.originalText.isEmpty)
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("memeAndCopyToClipboardButton")
    }
}

#Preview {
    ContentView()
}
