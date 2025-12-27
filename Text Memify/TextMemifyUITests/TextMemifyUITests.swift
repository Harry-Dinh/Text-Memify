//
//  TextMemifyUITests.swift
//  TextMemifyUITests
//
//  Created by Harry Dinh on 2025-12-27.
//

import XCTest

class TextMemifyUITests: XCTestCase {
    let app = XCUIApplication()
    
    // MARK: - Helper Functions
    
    func launchApp() {
        app.launch()
    }
    
    func focusOnWindow(_ window: TextMemifyWindows) {
        let focusedWindow = app.windows[window.rawValue]
        if focusedWindow.waitForExistence(timeout: 3) {
            focusedWindow.click()
        }
    }
    
    // MARK: - Sub-test functions
    
    func verifyMainWindowContent(withMemeFormatButton: Bool = false) {
        var elements: [XCUIElement] = [
            app.textFields["originalTextField"],
            app.textFields["resultTextField"],
            app.buttons["showHistoryButton"],
            app.buttons["clearButton"],
            app.buttons["memifyButton"],
        ]
        
        if withMemeFormatButton {
            elements.append(app.buttons["formatOptionButton"])
        }
        
        for element in elements {
            XCTAssertTrue(element.waitForExistence(timeout: 1), "Element \(element.identifier) not found")
        }
    }
    
    func navigateToHistoryView() {
        let showHistoryButton = app.buttons["showHistoryButton"]
        XCTAssertTrue(showHistoryButton.waitForExistence(timeout: 1), "Show History button not found")
        showHistoryButton.click()
        focusOnWindow(.history)
    }
    
    func verifyHistoryWindowContent() {
        let elements = [
            app.buttons["copyResultButton"],
            app.searchFields.firstMatch
        ]
        
        for element in elements {
            XCTAssertTrue(element.waitForExistence(timeout: 1), "Element \(element.identifier) not found")
        }
    }
}
