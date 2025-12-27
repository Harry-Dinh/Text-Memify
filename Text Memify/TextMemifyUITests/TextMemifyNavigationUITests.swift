//
//  TextMemifyNavigationUITests.swift
//  Text Memify
//
//  Created by Harry Dinh on 2025-12-27.
//

import XCTest

class TextMemifyNavigationUITests: TextMemifyUITests {
    func test_verifyMainWindowContent() throws {
        launchApp()
        focusOnWindow(.mainWindow)
        verifyMainWindowContent()
    }
}
