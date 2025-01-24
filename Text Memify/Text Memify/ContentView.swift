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
            HStack {
                Text("Text Memify")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            GroupBox {
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
            }
            
            HStack {
                Spacer()
                
                Button("Copy to Clipboard") {}
                    .disabled(viewModel.resultText.isEmpty)
                Button("Memify!") { viewModel.memify() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(viewModel.originalText.isEmpty)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .frame(width: 350)
}
