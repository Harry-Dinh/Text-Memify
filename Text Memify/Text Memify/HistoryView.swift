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
    @State private var searchText = ""

    var body: some View {
        ZStack {
            if viewModel.memeHistory.isEmpty {
                noEntriesTitle
            }
            mainListView
        }
        .onChange(of: viewModel.memeHistory) {
            viewModel.updateHistoryList()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                toolbarItems(selectedRow)
            }
        }

        .alert("title_delete_all_entries", isPresented: $viewModel.showDeleteAllAlert) {
            alertButtons
        }
    }

    // MARK: - Subviews

    private var mainListView: some View {
        List(selection: $selectedRow) {
            ForEach(Array(viewModel.memeHistory.values), id: \.self) { value in
                if let key = getKey(for: value) {
                    rowView(key, value)
                        .contextMenu {
                            rowContextMenuContent(key, value)
                        }
                        .tag(value)
                }
            }
        }
        .scrollContentBackground(viewModel.memeHistory.isEmpty ? .hidden : .visible)
        .background(Color.clear)
        .listStyle(.inset)
        .searchable(text: $searchText)
    }

    private func toolbarItems(_ value: String?) -> some View {
        Group {
            Button(action: {
                viewModel.copyToPasteboard(value)
            }) {
                Label("label_copy", systemImage: "doc.on.doc")
            }
            .disabled(selectedRow == nil)
            .help("label_tooltip_copy")
            .accessibilityLabel(Text("label_copy"))
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("copyResultButton")

            Menu {
                Button("label_delete_entry") {
                    if let selectedKey = selectedRow {
                        viewModel.deleteEntry(with: selectedKey)
                        selectedRow = nil
                        viewModel.saveToHistory()
                    }
                }
                .accessibilityLabel(Text("label_delete_entry"))
                .accessibilityAddTraits(.isButton)
                .accessibilityIdentifier("deleteEntryButton")
                
                Button("label_clear_history") {
                    viewModel.showDeleteAllAlert.toggle()
                }
                .accessibilityLabel(Text("label_clear_history"))
                .accessibilityAddTraits(.isButton)
                .accessibilityIdentifier("clearHistoryButton")
            } label: {
                Label("label_delete", systemImage: "trash")
            } primaryAction: {
                // Delete the currently selected row by default
                if let selectedKey = selectedRow {
                    viewModel.deleteEntry(with: selectedKey)
                    selectedRow = nil
                    viewModel.saveToHistory()
                }
            }
            .disabled(selectedRow == nil)
            .help("label_tooltip_delete_entry")
            .accessibilityLabel(Text("label_delete"))
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("deleteOptionMenu")
        }
    }

    private var alertButtons: some View {
        Group {
            alertCancelButton
            alertDeleteAllButton
        }
    }

    private var alertCancelButton: some View {
        Button("label_cancel", role: .cancel) {}
            .accessibilityLabel(Text("label_cancel"))
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("alertCancelButton")
    }

    private var alertDeleteAllButton: some View {
        Button("label_delete_all", role: .destructive) {
            viewModel.clearHistory()
            selectedRow = nil
            viewModel.saveToHistory()
        }
        .accessibilityLabel(Text("label_delete_all"))
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("alertDeleteAllButton")
    }

    private func rowView(_ key: String, _ value: String) -> some View {
        VStack(alignment: .leading) {
            Text(key)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
        }
        .accessibilityAddTraits(.isStaticText)
        .accessibilityElement(children: .ignore)
    }

    private func rowContextMenuContent(_ key: String, _ value: String) -> some View {
        Group {
            contextMenuCopySection(key, value)
            contextMenuDeleteSection
        }
    }

    private var contextMenuDeleteSection: some View {
        Section {
            Button("label_delete") {
                if let selectedKey = selectedRow {
                    viewModel.deleteEntry(with: selectedKey)
                }
            }
            .accessibilityLabel(Text("label_delete"))
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("contextMenuDeleteButton")
        }
    }

    private func contextMenuCopySection(_ key: String, _ value: String) -> some View {
        Section {
            copyOriginalTextButton(key)
            copyResultTextButton(value)
        }
    }

    private func copyOriginalTextButton(_ key: String) -> some View {
        Button("label_copy_original_text") {
            viewModel.copyToPasteboard(key)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("contextMenuCopyOriginalTextButton")
    }

    private func copyResultTextButton(_ value: String) -> some View {
        Button("label_copy_result_text") {
            viewModel.copyToPasteboard(value)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("contextMenuCopyResultTextButton")
    }

    private var noEntriesTitle: some View {
        Text("label_no_entries")
            .font(.title)
            .foregroundStyle(.secondary)
            .accessibilityLabel(Text("label_no_entries"))
            .accessibilityAddTraits(.isStaticText)
            .accessibilityIdentifier("noEntriesTitle")
    }

    // MARK: - Helper Functions and Properties

    private func getKey(for value: String) -> String? {
        guard let firstPair = viewModel.memeHistory.first(where: { $0.value == value }) else {
            return nil
        }
        return firstPair.key
    }
}
