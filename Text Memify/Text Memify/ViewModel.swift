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
    
    private var canCopyToClipboard = false
    private let userDefault = UserDefaults.standard
    
    public var originalText = ""
    public var selectedOption = 0
    public var resultText = ""
    public var memeHistory: [String: String] = [:]
    public var storeDuplicates = true
    
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
    
    public func saveDefaultMemeOption(_ memeOption: Int) {
        userDefault.set(memeOption, forKey: TMConstants.DEFAULT_MEME_OPTION_KEY)
    }
    
    public func loadDefaultMemeOption() -> Int {
        return userDefault.integer(forKey: TMConstants.DEFAULT_MEME_OPTION_KEY)
    }
    
    public func saveToHistory() {
        // No need to check if the string is empty because in the UI, the button is already disabled if empty
        // Check if there is a duplicate (if the option is on)
        if storeDuplicates {
            if let value = memeHistory[originalText], value == resultText {
                // Exit to prevent adding a duplicate
                return
            }
        }
        
        // Otherwise, proceed to append the entry then write the latest version of the dictionary to UserDefaults
        memeHistory[originalText] = resultText
        userDefault.set(memeHistory, forKey: TMConstants.ENTRIES_HISTORY_KEY)
    }
    
    public func loadHistory() {
        guard let historyEntries = userDefault.object(forKey: TMConstants.ENTRIES_HISTORY_KEY) as? [String: String] else {
            print("No entries detected in local storage")
            return
        }
        memeHistory = historyEntries
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
