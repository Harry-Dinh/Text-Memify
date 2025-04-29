//
//  HistoryView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-01-31.
//

import SwiftUI

struct HistoryView: View {
    
    @State private var viewModel = TMViewModel.instance
    @State private var selectedRow: String?

    var body: some View {
        ZStack {
            if viewModel.memeHistory.isEmpty {
                Text("No Entries")
                    .font(.title)
                    .foregroundStyle(.secondary)
            }

            List(selection: $selectedRow) {
                ForEach(Array(viewModel.memeHistory.keys), id: \.self) { key in
                    if let value = viewModel.memeHistory[key] {
                        VStack(alignment: .leading) {
                            Text(key)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(value)
                        }
                        .contextMenu {
                            Button("Copy") {
                                NSPasteboard.general.setString(value, forType: .string)
                                print("Successfully copied value to pasteboard!")
                            }
                            Button("Delete") {
                                // Delete selected row
                                if let selectedKey = selectedRow {
                                    viewModel.deleteEntry(with: selectedKey)
                                    selectedRow = nil
                                    viewModel.saveToHistory()
                                }
                            }
                        }
                        .tag(key)
                    }
                }
            }
            .scrollContentBackground(viewModel.memeHistory.isEmpty ? .hidden : .visible)
        }
        .listStyle(.inset)
        .searchable(text: .constant(""), prompt: "Search")      // TODO: Still need to implement search functionality!
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                .disabled(selectedRow == nil)

                Menu {
                    Button("Delete Entry") {
                        if let selectedKey = selectedRow {
                            viewModel.deleteEntry(with: selectedKey)
                            selectedRow = nil
                            viewModel.saveToHistory()
                        }
                    }
                    Button("Clear History...") {
                        viewModel.showDeleteAllAlert.toggle()
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                } primaryAction: {
                    // Delete the currently selected row by default
                    if let selectedKey = selectedRow {
                        viewModel.deleteEntry(with: selectedKey)
                        selectedRow = nil
                        viewModel.saveToHistory()
                    }
                }
                .disabled(selectedRow == nil)
            }
        }
        .alert("Delete All Entries?", isPresented: $viewModel.showDeleteAllAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete All", role: .destructive) {
                viewModel.clearHistory()
                selectedRow = nil
                viewModel.saveToHistory()
            }
        }
    }
}

//#Preview {
//    HistoryView()
//        .frame(width: 400)
//}
