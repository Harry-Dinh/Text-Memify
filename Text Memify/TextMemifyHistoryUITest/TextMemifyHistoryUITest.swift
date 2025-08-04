//
//  TextMemifyHistoryUITest.swift
//  TextMemifyHistoryUITest
//
//  Created by Harry Dinh on 2025-08-03.
//

import XCTest

final class TextMemifyHistoryUITest: TextMemifyUITestBase {
    func test_navigateToHistoryView() throws {
        setupSequence()
        navigateToHistoryView()
    }
}
