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
    static let instance = TMViewModel()
    
    private var canCopyToClipboard = false
    private let userDefault = UserDefaults.standard
    private let pasteboard = NSPasteboard.general

    var originalText = ""
    var selectedOption: TMMemeFormats = .wideLowercased
    var resultText = ""
    var memeHistory: [String: String] = [:]
    var storeDuplicates = true
    var showDeleteAllAlert = false
    var shouldCopyToClipboard = false
    var copyToClipboardSettings = false
    var showFormatOptionPopover = false
    var randomizeCaseForUpAndDown = false

    public func memify() {
        switch selectedOption {
        case .wideLowercased:
            widenText(capitalized: false)
            canCopyToClipboard = true
            break
        case .wideUppercased:
            widenText(capitalized: true)
            canCopyToClipboard = true
            break
        case .reversed:
            resultText = String(originalText.reversed())
            canCopyToClipboard = true
            break
        case .upAndDown:
            resultText = upAndDownText()
            canCopyToClipboard = true
            break
        }
    }
    
    func copyToClipboard() {
        if resultText.isEmpty || !canCopyToClipboard {
            return
        }
        pasteboard.clearContents()
        pasteboard.setString(resultText, forType: .string)
    }

    func copyToPasteboard(_ text: String?) {
        guard let unwrappedText = text,
              !unwrappedText.isEmpty || canCopyToClipboard else {
            return
        }
        pasteboard.clearContents()
        pasteboard.setString(unwrappedText, forType: .string)
    }

    func clearFields() {
        originalText = ""
        resultText = ""
    }
    
    func saveDefaultMemeOption(_ memeOption: TMMemeFormats) {
        userDefault.set(memeOption, forKey: TMConstants.DEFAULT_MEME_OPTION_KEY)
    }
    
    func loadDefaultMemeOption() -> TMMemeFormats {
        guard let defaultMemeOption = userDefault.value(forKey: TMConstants.DEFAULT_MEME_OPTION_KEY) as? TMMemeFormats else {
            return .wideLowercased
        }
        return defaultMemeOption
    }
    
    func saveToHistory() {
        if resultText.isEmpty && originalText.isEmpty {
            return
        }

        if storeDuplicates {
            if let value = memeHistory[originalText], value == resultText {
                // Exit to prevent adding a duplicate
                return
            }
        }

        memeHistory[originalText] = resultText
        userDefault.set(memeHistory, forKey: TMConstants.ENTRIES_HISTORY_KEY)
    }
    
    func loadHistory() {
        guard let historyEntries = userDefault.object(forKey: TMConstants.ENTRIES_HISTORY_KEY) as? [String: String] else {
            print("No entries detected in local storage")
            return
        }
        memeHistory = historyEntries
    }

    func deleteEntry(with key: String) {
        if memeHistory.removeValue(forKey: key) == nil {
            print("Unable to remove entry with key: \(key)")
        } else {
            print("Successfully removed entry")
        }
    }

    func updateHistoryList() {
        userDefault.setValue(memeHistory, forKey: TMConstants.ENTRIES_HISTORY_KEY)
    }

    func clearHistory() {
        memeHistory.removeAll()                                             // Remove all entries from dictionary
        userDefault.removeObject(forKey: TMConstants.ENTRIES_HISTORY_KEY)   // Remove entries from UserDefaults
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
        var isUpper = randomizeCaseForUpAndDown ? Bool.random() : false
        return temp.map { char in
            if char.isLetter {
                let transformedChar = isUpper ? char.uppercased() : char.lowercased()
                if randomizeCaseForUpAndDown {
                    isUpper = .random()
                } else {
                    isUpper.toggle()
                }
                return transformedChar
            } else {
                return String(char)
            }
        }.joined()
    }
}
