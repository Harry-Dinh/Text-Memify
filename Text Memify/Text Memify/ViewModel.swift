//
//  ViewModel.swift
//  Text Memify
//
//  Created by Harry Dinh on 2024-12-06.
//

import Foundation
import SwiftUI

@Observable
class TMViewModel {
    
    public static let instance = TMViewModel()
    
    public var originalText = ""
    public var selectedOption = 0
    public var resultText = ""
    private var canCopyToClipboard = false
    
    public func memify() {
        switch selectedOption {
            case 0:
                widenText(capitalized: false)
                canCopyToClipboard = true
                break
            case 1:
                widenText(capitalized: true)
                canCopyToClipboard = true
                break
            case 2:
                resultText = String(originalText.reversed())
                canCopyToClipboard = true
                break
            case 3:
                resultText = upAndDownText()
                canCopyToClipboard = true
                break
            default:
                print("Something went wrong...")
                canCopyToClipboard = false
                break
        }
    }
    
    public func copyToClipboard() {
        if resultText.isEmpty || !canCopyToClipboard {
            return
        }
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(resultText, forType: .string)
    }
    
    public func clearFields() {
        originalText = ""
        resultText = ""
    }
    
    private func widenText(capitalized: Bool) {
        var temp = originalText
        if capitalized {
            temp = temp.uppercased()
        }
        resultText = temp.map { String($0) }.joined(separator: " ")
    }
    
    private func upAndDownText() -> String {
        let temp = originalText
        var isUpper = false      // Start with lowercase
        return temp.map { char in
            if char.isLetter {
                let transformedChar = isUpper ? char.uppercased() : char.lowercased()
                isUpper.toggle()    // Flip the case for the next character
                return transformedChar
            } else {
                return String(char)     // Keep non-letter characters unchanged
            }
        }.joined()
    }
}
