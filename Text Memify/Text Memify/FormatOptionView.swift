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
        Form {
            Text("label_format_option")
                .font(.headline)
                .accessibilityLabel(Text("label_format_option"))
                .accessibilityAddTraits([.isStaticText, .isHeader])
                .accessibilityIdentifier("formatOptionHeader")
            
            wideFormatView
            upAndDownFormatView
        }
        .padding()
    }
    
    private var upAndDownFormatView: some View {
        GroupBox("label_up_and_down_header") {
            Toggle("format_up_and_down_random_case", isOn: $viewModel.randomizeCaseForUpAndDown)
                .disabled(viewModel.selectedOption != .upAndDown)
                .padding(TMConstants.GENERAL_GROUP_BOX_PADDING)
                .accessibilityLabel(Text("format_up_and_down_random_case"))
                .accessibilityAddTraits(.isToggle)
                .accessibilityIdentifier("upAndDownFormatRandomOptionToggle")
        }
    }
    
    private var wideFormatView: some View {
        GroupBox("label_wide_format_header") {
            Toggle("label_use_uppercase_for_wide", isOn: $viewModel.useUppercaseForWideFormat)
                .disabled(viewModel.selectedOption != .wide)
                .padding(TMConstants.GENERAL_GROUP_BOX_PADDING)
                .accessibilityLabel(Text("label_use_uppercase_for_wide"))
                .accessibilityAddTraits(.isToggle)
                .accessibilityIdentifier("wideFormatOptionToggle")
        }
    }
}

#Preview {
    FormatOptionView(TMViewModel.instance)
}
