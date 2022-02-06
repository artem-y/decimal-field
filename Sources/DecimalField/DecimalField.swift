//
//  String+Extensions.swift
//
//
//  Created by Artem Yelizarov on 18.01.2022.
//

import UIKit

/// Text field that manages decimal input.
///
/// It provides default keyboard with system Done button and processes input, allowing only
/// decimal numbers. Few other cases of commonly needed behaviour are included:
/// - trimming zeros in a decimal number when editing ends
/// - resetting the input to `0` when editing ends and the field is empty
/// - clearing the field when editing begins and the input is `0`
///
/// These are "always on" by default but can be turned off via related properties.
public class DecimalField: UITextField {

    /// Tells the text field whether it should allow `minus` in the input.
    ///
    /// By default this property is set to `true`.
    /// When the text field already has input with minus and this property is reset to `false`,
    /// the minus will get immediately removed.
    public var allowsNegativeNumbers = true {
        didSet {
            trimMinusIfNeeded()
        }
    }

    /// Tells the text field whether it should clear `0` on `editingDidBegin` event.
    /// By default this property is set to `true`.
    public var isClearingZeroWhenEditingBegins = true

    /// Tells the text field whether it should trim the text and ensure it is not empty when editing ends.
    /// By default this property is set to `true`.
    public var trimsAndSetsNonEmptyWhenEditingEnds = true

    /// Same as the `UITextField`'s property, but the text is processed.
    ///
    /// Whenever this property is set, it filters and modifies the new value and stores the processed result.
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
        placeholder = .zero
        configureKeyboard()
        addActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        let button = makeDoneButton()
        toolBar.setItems([.flexibleSpace(), button], animated: true)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }

    private func makeDoneButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            systemItem: .done,
            primaryAction: UIAction { [weak self] _ in
                self?.stopEditing()
            }
        )
    }

    private func addActions() {
        handleEvents(.editingDidBegin) { [weak self] in
            guard let self = self, self.isClearingZeroWhenEditingBegins else { return }
            self.clearZero()
        }

        handleEvents(.editingChanged) { [weak self] in
            self?.reassignText()
        }

        handleEvents([.editingDidEndOnExit, .editingDidEnd]) { [weak self] in
            self?.ensureNonEmptyTrimmedText()
        }
    }

    private func handleEvents(_ controlEvents: UIControl.Event, handler: @escaping () -> Void) {
        let action = UIAction { _ in handler() }
        addAction(action, for: controlEvents)
    }

    private func stopEditing() {
        endEditing(true)
        resignFirstResponder()
    }

    private func reassignText() {
        let text = self.text
        self.text = text
    }

    // MARK: Text Processing

    private func trimMinusIfNeeded() {
        guard let text = text else { return }
        let processor = makeTextProcessor()
        self.text = processor.trimMinusIfNeeded(in: text)
    }

    private func process(_ text: String) -> String {
        var processor = makeTextProcessor()
        return processor.process(text)
    }

    private func clearZero() {
        guard let text = text else { return }
        let processor = makeTextProcessor()
        self.text = processor.clearZero(text)
    }

    private func ensureNonEmptyTrimmedText() {
        guard trimsAndSetsNonEmptyWhenEditingEnds else { return }
        var processor = makeTextProcessor()
        text = processor.makeNonEmptyTrimmedText(from: text ?? .empty)
    }

    private func makeTextProcessor() -> DecimalTextProcessor {
        return DecimalTextProcessor(allowsNegativeNumbers: allowsNegativeNumbers)
    }
}
