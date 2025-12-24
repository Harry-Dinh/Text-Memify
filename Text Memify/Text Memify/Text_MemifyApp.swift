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
        viewModel.copyToClipboardSettings = UserDefaults.standard.bool(forKey: "copyToClipboardSettings")
        viewModel.shouldCopyToClipboard = viewModel.copyToClipboardSettings
        viewModel.loadHistory()
    }
    
    var body: some Scene {
        Window("Text Memify", id: TMConstants.MAIN_WINDOW_ID) {
            ContentView()
                .windowResizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .onDisappear {
                    // Quit the app when the main window is closed
                    NSApplication.shared.terminate(nil)
                }
        }
        .defaultSize(width: 450, height: 170)
        .commands {
            CommandMenu("label_menu_format") {
                Picker(selection: $viewModel.selectedOption) {
                    Text("format_wide_lowercased").tag(0)
                        .keyboardShortcut("1")
                    Text("format_wide_uppercased").tag(1)
                        .keyboardShortcut("2")
                    Text("format_reversed").tag(2)
                        .keyboardShortcut("3")
                    Text("format_up_and_down").tag(3)
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
                Button("label_clear_text_fields") {
                    viewModel.clearFields()
                }
                .keyboardShortcut("C", modifiers: [.shift, .command])
                
                Toggle(isOn: $viewModel.shouldCopyToClipboard) {
                    Text("label_copy_to_clipboard_after_memify")
                }
            }
        }
        
        Window("label_history", id: TMConstants.HISTORY_WINDOW_ID) {
            HistoryView()
                .windowFullScreenBehavior(.disabled)
        }
        
        // The settings/preferences pane for Text Memify
        Settings {
            TMSettingsView()
        }
    }
}
