//
//  DecimalField+TextProcessor.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import Foundation

extension DecimalField {
    struct TextProcessor {
        private let allowedSymbols = "1234567890."
        private let minus: Character = "-"
    }
}

// MARK: - DecimalTextProcessing

extension DecimalField.TextProcessor: DecimalTextProcessing {
    func process(_ text: String) -> String {
        let prefix = getNegativeOrEmptyPrefix(from: text)
        let filteredText = text.filter(allowedSymbols.contains)
        return prefix + filteredText
    }
}

// MARK: - Private Methods

extension DecimalField.TextProcessor {
    private func getNegativeOrEmptyPrefix(from text: String) -> String {
        guard let firstChar = text.first,
              firstChar == minus else { return .empty }
        return String(firstChar)
    }
}
