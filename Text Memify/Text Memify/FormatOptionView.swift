//
//  FormatOptionView.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-12-23.
//

import SwiftUI

struct FormatOptionView: View {
    @Bindable var viewModel: TMViewModel
    
    init(_ viewModel: TMViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("label_format_option")
                .font(.headline)
                .accessibilityLabel(Text("label_format_option"))
                .accessibilityAddTraits([.isStaticText, .isHeader])
                .accessibilityIdentifier("formatOptionHeader")
            
            Toggle("format_up_and_down_random_case", isOn: $viewModel.randomizeCaseForUpAndDown)
                .accessibilityLabel(Text("format_up_and_down_random_case"))
                .accessibilityAddTraits(.isToggle)
                .accessibilityIdentifier("upAndDownFormatRandomOptionToggle")
        }
        .padding()
    }
}

#Preview {
    FormatOptionView(TMViewModel.instance)
}
