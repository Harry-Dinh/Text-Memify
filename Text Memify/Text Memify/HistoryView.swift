//
//  HistoryView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-01-31.
//

import SwiftUI

struct HistoryView: View {
    
    @State private var viewModel = TMViewModel.instance
    
    var body: some View {
        List(Array(viewModel.memeHistory.keys), id: \.self) { key in
            if let value = viewModel.memeHistory[key] {
                VStack(alignment: .leading) {
                    Text(key)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(value)
                }
                .contextMenu {
                    Button("Copy") {}
                    Button("Delete") {}
                }
            }
        }
        .listStyle(.inset)
        .searchable(text: .constant(""), prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {}) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
                
                Menu {
                    Button("Delete Entry") {}
                    Button("Clear History...") {}
                } label: {
                    Label("Delete", systemImage: "trash")
                } primaryAction: {
                    print("Delete entry called")
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .frame(width: 400)
}
