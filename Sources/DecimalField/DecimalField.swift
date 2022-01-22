//
//  String+Extensions.swift
//
//
//  Created by Artem Yelizarov on 18.01.2022.
//

import UIKit

public class DecimalField: UITextField {

    public var allowsNegativeNumbers = true {
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
        placeholder = .zero
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
            systemItem: .done,
            primaryAction: UIAction { [weak self] _ in
                self?.stopEditing()
            }
        )
        toolBar.setItems([.flexibleSpace(), button], animated: true)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }

    private func addActions() {
        handleEvents(.editingDidBegin) { [weak self] in
            self?.clearZero()
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

    private func process(_ text: String) -> String {
        var processor = makeTextProcessor()
        return processor.process(text)
    }

    private func trimMinusIfNeeded() {
        guard let text = text else { return }
        let processor = makeTextProcessor()
        self.text = processor.trimMinusIfNeeded(in: text)
    }

    private func clearZero() {
        guard let text = text else { return }
        let processor = makeTextProcessor()
        self.text = processor.clearZero(text)
    }

    private func reassignText() {
        let text = self.text
        self.text = text
    }

    private func ensureNonEmptyTrimmedText() {
        var processor = makeTextProcessor()
        text = processor.makeNonEmptyTrimmedText(from: text ?? .empty)
    }

    private func stopEditing() {
        endEditing(true)
        resignFirstResponder()
    }

    private func makeTextProcessor() -> DecimalTextProcessor {
        return DecimalTextProcessor(allowsNegativeNumbers: allowsNegativeNumbers)
    }
}

// MARK: - Default

private extension DecimalField {
    enum Text {
        static let doneButton = "Done"
    }
}

