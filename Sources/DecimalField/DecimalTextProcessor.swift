//
//  DecimalTextProcessor.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import Foundation

struct DecimalTextProcessor {
    private let allowsNegativeNumbers: Bool

    private let minus = Self.minus
    private let floatingPoint = Self.floatingPoint
    private let comma = Self.comma

    private var text: String = .empty
    private var hasNegativePrefix = false

    private var shouldAddMinus: Bool {
        allowsNegativeNumbers && hasNegativePrefix
    }

    private var isZeroEquivalent: Bool {
        text.isEmpty || text == String(floatingPoint) || Double(text) == .zero
    }

    init(allowsNegativeNumbers: Bool = true) {
        self.allowsNegativeNumbers = allowsNegativeNumbers
    }
}

// MARK: - Processing

extension DecimalTextProcessor {
    mutating func process(_ input: String) -> String {
        if input == String(minus) {
            return input
        }

        text = input

        replaceCommasWithFloatingPoints()
        checkIfHasMinus()
        filterAllowedSymbols()

        if let floatingPointIndex = text.firstIndex(of: floatingPoint) {
            keepSingleFloatingPoint(at: floatingPointIndex)
            addZeroToStartIfNeeded()
        }

        addMinusIfNeeded()

        return text
    }

    mutating func makeNonEmptyTrimmedText(from processedText: String) -> String {
        text = processedText

        if isZeroEquivalent {
            return .zero
        } else {
            checkIfHasMinus()
            trimText()
            return text
        }
    }

    func trimMinusIfNeeded(in text: String) -> String {
        guard shouldTrimMinus(in: text) else { return text }
        let trimmedText = String(text.dropFirst())
        return trimmedText
    }

    func clearZero(_ text: String) -> String {
        let isZero = Double(text) == .zero
        return isZero ? .empty : text
    }
}

// MARK: - Private Methods

extension DecimalTextProcessor {
    private mutating func trimText() {
        if hasNegativePrefix {
            text.removeFirst()
        }

        if text.contains(floatingPoint) {
            let zeroSet = CharacterSet(charactersIn: .zero)
            text = text.trimmingCharacters(in: zeroSet)

            addZeroToStartIfNeeded()

            if text.last == floatingPoint {
                text.removeLast()
            }
        } else if text.hasPrefix(.zero) {
            let trimmedSubstring = text.drop { $0 == "0" }
            text = String(trimmedSubstring)
        }

        addMinusIfNeeded()
    }

    private mutating func replaceCommasWithFloatingPoints() {
        text = text.replacingOccurrences(of: comma, with: String(floatingPoint))
    }

    private mutating func filterAllowedSymbols() {
        text = text.filter(isAllowedSymbol)
    }

    private func isAllowedSymbol(_ character: Character) -> Bool {
        return character.isNumber || character == floatingPoint
    }

    private mutating func removeFloatingPoints() {
        text = text.replacingOccurrences(of: String(floatingPoint), with: String.empty)
    }

    private mutating func addZeroToStartIfNeeded() {
        guard text.first == floatingPoint else { return }
        text = .zero + text
    }

    private mutating func keepSingleFloatingPoint(at dotIndex: String.Index) {
        removeFloatingPoints()
        text.insert(floatingPoint, at: dotIndex)
    }

    private mutating func checkIfHasMinus() {
        var previousCharacter: Character?

        for character in text {
            if let previousCharacter = previousCharacter {
                if previousCharacter.isNumber {
                    continue
                } else if previousCharacter == minus, character.isNumber {
                    hasNegativePrefix = true
                    break
                }
            }

            previousCharacter = character
        }
    }

    private mutating func addMinus() {
        text = String(minus) + text
    }

    private mutating func addMinusIfNeeded() {
        if shouldAddMinus {
            addMinus()
        }
    }

    private func shouldTrimMinus(in text: String) -> Bool {
        return !allowsNegativeNumbers && text.first == minus
    }
}

// MARK: - Default Values

extension DecimalTextProcessor {
    private static let minus: Character = "-"
    private static let floatingPoint: Character = "."
    private static let comma = ","
}
