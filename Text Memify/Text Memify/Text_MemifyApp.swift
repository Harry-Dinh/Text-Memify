//
//  Text_MemifyApp.swift
//  Text Memify
//
//  Created by Harry Dinh on 2024-12-06.
//

import SwiftUI

@main
struct Text_MemifyApp: App {
    
    @State private var viewModel = TMViewModel.instance
    
    init() {
        viewModel.selectedOption = viewModel.loadDefaultMemeOption()
    }
    
    var body: some Scene {
        Window("Text Memify", id: TMConstants.MAIN_WINDOW_ID) {
            ContentView()
                .windowResizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
        }
        .defaultSize(width: 450, height: 170)
        .commands {
            CommandMenu("Format") {
                Picker(selection: $viewModel.selectedOption) {
                    Text("w i d e").tag(0)
                        .keyboardShortcut("1")
                    Text("W I D E").tag(1)
                        .keyboardShortcut("2")
                    Text("(desreveR) Reversed").tag(2)
                        .keyboardShortcut("3")
                    Text("Up AnD dOwN").tag(3)
                        .keyboardShortcut("4")
                } label: {
                    EmptyView()
                }
                .pickerStyle(.inline)
            }
            
            CommandGroup(replacing: .undoRedo) {
                EmptyView()
            }
            
            CommandGroup(replacing: .newItem) {
                EmptyView()
            }
            
            CommandGroup(replacing: .pasteboard) {
                Button("Clear Text Fields") {
                    viewModel.clearFields()
                }
                .keyboardShortcut("C", modifiers: [.shift, .command])
            }
        }
        
        Window("History", id: TMConstants.HISTORY_WINDOW_ID) {
            HistoryView()
                .windowFullScreenBehavior(.disabled)
        }
        
        // The settings/preferences pane for Text Memify
        Settings {
            TMSettingsView()
        }
    }
}
