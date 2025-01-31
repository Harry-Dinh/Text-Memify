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
                TextField("Text:", text: $viewModel.originalText)
                
                Picker(selection: $viewModel.selectedOption) {
                    Text("w i d e").tag(0)
                    Text("W I D E").tag(1)
                    Text("(desreveR) Reversed").tag(2)
                    Text("Up AnD dOwN").tag(3)
                } label: {
                    Text("Meme Format:")
                }
                
                TextField("Result:", text: $viewModel.resultText)
                    .disabled(true)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            HStack {
                Button("Show History") {
                    openWindow.callAsFunction(id: TMConstants.HISTORY_WINDOW_ID)
                }
                
                Spacer()
                
                Button("Clear") {
                    viewModel.clearFields()
                }
                
                Button("Memify and Copy to Clipboard") {
                    viewModel.memify()
                    viewModel.copyToClipboard()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(viewModel.originalText.isEmpty)
            }
        }
        .padding()
        .frame(minWidth: TMConstants.MAIN_VIEW_DIMENSION, maxWidth: TMConstants.MAIN_VIEW_DIMENSION)
    }
}

#Preview {
    ContentView()
}
