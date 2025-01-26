//
//  ContentView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2024-12-06.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = TMViewModel.instance
    
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
                    Text("Options:")
                }
                
                TextField("Result:", text: $viewModel.resultText)
                    .disabled(true)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            
            HStack {
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
        .frame(minWidth: 450, maxWidth: 450)
    }
}

#Preview {
    ContentView()
}
