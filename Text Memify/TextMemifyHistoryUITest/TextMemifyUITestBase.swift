//
//  TextMemifyUITestBase.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-08-03.
//

import XCTest

class TextMemifyUITestBase: XCTestCase {
    private let app = XCUIApplication()

    func setupSequence() {
        app.launch()
    }

    func navigateToHistoryView() {
        let historyButton = app.buttons["showHistoryButton"]
        XCTAssertTrue(historyButton.exists, "History button doesn't exist!")
        historyButton.click()

        // History view
        let deleteButton = app.buttons["deleteOptionMenu"]
        let copyButton = app.buttons["copyResultButton"]
        XCTAssertTrue(deleteButton.exists, "Delete button doesn't exist")
        XCTAssertTrue(copyButton.exists, "Copy button doesn't exist")
    }
}
