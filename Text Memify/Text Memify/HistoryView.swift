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
        List {
            ForEach(0..<10) { _ in
                Text("NCC-1701")
                    .selectionDisabled(false)
            }
        }
        .listStyle(.inset)
        .searchable(text: .constant(""), prompt: "Search")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "doc.on.doc")
                }
                .accessibilityLabel(Text("Copy to Clipboard"))
                
                Button(action: {}) {
                    Image(systemName: "trash")
                }
                .accessibilityLabel(Text("Delete Entry"))
            }
        }
    }
}

#Preview {
    HistoryView()
        .frame(width: 400)
}
