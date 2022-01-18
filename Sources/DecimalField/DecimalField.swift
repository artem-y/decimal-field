//
//  String+Extensions.swift
//
//
//  Created by Artem Yelizarov on 18.01.2022.
//

import UIKit

public class DecimalField: UITextField {

    var allowsNegativeNumbers = true {
        didSet {
            trimMinusIfNeeded()
        }
    }

    public override var text: String? {
        get {
            super.text
        }
        set {
            super.text = newValue.map(process)
        }
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = Char.zero
        configureKeyboard()
        addActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

extension DecimalField {
    private func configureKeyboard() {
        keyboardType = .decimalPad
        returnKeyType = .done
        inputAccessoryView = makeKeyboardToolBar()
    }

    private func makeKeyboardToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(
            title: Text.doneButton,
            style: .done,
            target: self,
            action: #selector(stopEditing)
        )
        toolBar.setItems([.flexibleSpace(), button], animated: true)
                toolBar.setItems([button], animated: true)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }

    private func addActions() {
        addTarget(self, action: #selector(clearZero), for: .editingDidBegin)
        addTarget(self, action: #selector(reassignText), for: .editingChanged)
        addTarget(self, action: #selector(ensureNonEmptyTrimmedText), for: .editingDidEndOnExit)
        addTarget(self, action: #selector(ensureNonEmptyTrimmedText), for: .editingDidEnd)
    }

    private func process(_ text: String) -> String {
        guard !text.isEmpty else { return text }

        var negativePrefix = String.empty
        if allowsNegativeNumbers, text.starts(with: Char.minus) {
            negativePrefix = Char.minus
        }

        guard text != negativePrefix else { return text }

        let filteredText = text
            .filter(Self.allowedSymbols.contains)
            .replacingOccurrences(of: Char.comma, with: String(Char.dot))
        var parts = filteredText
            .split(separator: Char.dot, maxSplits: 1, omittingEmptySubsequences: true)
        if parts.count > 1 {
            parts[1].removeAll(where: { $0 == Char.dot })
            let joinedText = parts.joined(separator: String(Char.dot))
            return negativePrefix + joinedText
        } else if parts.count == 1 {
            var intPart = String(parts[0])
            if filteredText.count > intPart.count {
                intPart.append(Char.dot)
            }
            return negativePrefix + intPart
        } else {
            return "\(Char.zero)\(Char.dot)"
        }
    }

    private func trimMinusIfNeeded() {
        guard !allowsNegativeNumbers,
              let text = text,
              text.starts(with: Char.minus) else { return }
        self.text?.removeFirst()
    }

    @objc private func clearZero() {
        guard text.map(Double.init) == .zero else { return }
        text = .empty
    }

    @objc private func reassignText() {
        let text = self.text
        self.text = text
    }

    @objc private func ensureNonEmptyTrimmedText() {
        if text == nil
            || text?.isEmpty == true
            || text == String(Char.dot)
            || text == Char.minus
            || text.map(Double.init) == .zero {
            self.text = Char.zero
        } else if var text = text {
            var negativePrefix = String.empty
            if text.starts(with: Char.minus) {
                negativePrefix = String(text.removeFirst())
            }

            if text.contains(Char.dot) {
                text = text.trimmingCharacters(in: .init(charactersIn: Char.zero))
                if text.starts(with: [Char.dot]) {
                    text = Char.zero + text
                }
                if text.hasSuffix(String(Char.dot)) {
                    text = String(text.dropLast())
                }
            } else if text.hasPrefix(Char.zero) {
                let trimmedSubstring = text.drop { String($0) == Char.zero }
                text = String(trimmedSubstring)
            }
            self.text = negativePrefix + text
        }
    }

    @objc private func stopEditing() {
        endEditing(true)
        resignFirstResponder()
    }
}

// MARK: - Default

private extension DecimalField {
    static let allowedSymbols = "0123456789.,"

    enum Text {
        static let doneButton = "Done"
    }

    enum Char {
        static let comma = ","
        static let dot: Character = "."
        static let minus = "-"
        static let zero = "0"
    }
}

