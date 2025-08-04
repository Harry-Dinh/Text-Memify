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

        .alert("Delete All Entries?", isPresented: $viewModel.showDeleteAllAlert) {
            alertButtons
        }
    }

    // MARK: - Subviews

    private var mainListView: some View {
        List(selection: $selectedRow) {
            ForEach(Array(viewModel.memeHistory.values), id: \.self) { value in
                rowView(value)
                    .contextMenu {
                        rowContextMenuContent(getKey(for: value), value)
                    }
                    .tag(value)
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
                Label("Copy", systemImage: "doc.on.doc")
            }
            .disabled(selectedRow == nil)
            .help("Copy result text")
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("copyResultButton")

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
            .help("Delete the selected entry")
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
        Button("Cancel", role: .cancel) {}
            .accessibilityAddTraits(.isButton)
            .accessibilityIdentifier("alertCancelButton")
    }

    private var alertDeleteAllButton: some View {
        Button("Delete All", role: .destructive) {
            viewModel.clearHistory()
            selectedRow = nil
            viewModel.saveToHistory()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("alertDeleteAllButton")
    }

    private func rowView(_ value: String) -> some View {
        VStack(alignment: .leading) {
            Text(getKey(for: value))
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
            Button("Delete") {
                if let selectedKey = selectedRow {
                    viewModel.deleteEntry(with: selectedKey)
                    selectedRow = nil
                }
            }
        }
    }

    private func contextMenuCopySection(_ key: String, _ value: String) -> some View {
        Section {
            copyOriginalTextButton(key)
            copyResultTextButton(value)
        }
    }

    private func copyOriginalTextButton(_ key: String) -> some View {
        Button("Copy Original Text") {
            viewModel.copyToPasteboard(key)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("copyOriginalTextButton")
    }

    private func copyResultTextButton(_ value: String) -> some View {
        Button("Copy Result Text") {
            viewModel.copyToPasteboard(value)
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityIdentifier("copyResultTextButton")
    }

    private var noEntriesTitle: some View {
        Text("No Entries")
            .font(.title)
            .foregroundStyle(.secondary)
            .accessibilityAddTraits(.isStaticText)
            .accessibilityIdentifier("noEntriesTitle")
    }

    // MARK: - Helper Functions and Properties

    private func getKey(for value: String) -> String {
        guard let firstPair = viewModel.memeHistory.first(where: { $0.value == value }) else {
            return "NO_KEY_PLACEHOLDER"
        }
        return firstPair.key
    }
}
