//
//  DecimalTextProcessor.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import Foundation

struct DecimalTextProcessor {
    let allowsNegativeNumbers: Bool

    private let allowedSymbols = Self.allowedSymbols
    private let minus = Self.minus
    private let floatingPoint = Self.floatingPoint
    private let comma = Self.comma

    private var text: String = .empty
    private var hasNegativePrefix = false

    private var shouldAddMinus: Bool {
        allowsNegativeNumbers && hasNegativePrefix
    }

    init(allowsNegativeNumbers: Bool = true) {
        self.allowsNegativeNumbers = allowsNegativeNumbers
    }
}

// MARK: - Processing

extension DecimalTextProcessor {
    mutating func process(_ text: String) -> String {
        if text == String(minus) {
            return text
        }

        self.text = text

        replaceCommasWithFloatingPoints()
        checkIfHasMinus()
        filterAllowedSymbols()

        if let floatingPointIndex = self.text.firstIndex(of: floatingPoint) {
            keepSingleFloatingPoint(at: floatingPointIndex)
            addZeroIfNeeded()
        }

        if shouldAddMinus {
            addMinus()
        }

        return self.text
    }
}

// MARK: - Private Methods

extension DecimalTextProcessor {
    private mutating func replaceCommasWithFloatingPoints() {
        text = text.replacingOccurrences(of: comma, with: String(floatingPoint))
    }

    private mutating func filterAllowedSymbols() {
        text = text.filter(allowedSymbols.contains)
    }

    private mutating func removeFloatingPoints() {
        text = text.replacingOccurrences(of: String(floatingPoint), with: String.empty)
    }

    private mutating func addZeroIfNeeded() {
        guard text.first == floatingPoint else { return }
        text = .zero + text
    }

    private mutating func keepSingleFloatingPoint(at dotIndex: String.Index) {
        removeFloatingPoints()
        text.insert(floatingPoint, at: dotIndex)
    }

    private mutating func checkIfHasMinus() {
        var previousChar: Character?

        for char in text {
            if let previousChar = previousChar {
                if previousChar.isNumber {
                    continue
                } else if previousChar == minus, char.isNumber {
                    hasNegativePrefix = true
                    break
                }
            }

            previousChar = char
        }
    }

    private mutating func addMinus() {
        text = String(minus) + text
    }
}

// MARK: - Default Values

extension DecimalTextProcessor {
    private static let allowedSymbols = "1234567890."
    private static let minus: Character = "-"
    private static let floatingPoint: Character = "."
    private static let comma = ","
}
