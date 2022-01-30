//
//  String+Extensions.swift
//
//
//  Created by Artem Yelizarov on 18.01.2022.
//

import XCTest
@testable import DecimalField

final class DecimalFieldTests: XCTestCase {
    typealias SUT = DecimalField

    private var sut: SUT!
    private let negativeIntegerText = "-123"
    private let integerText = "123"
    private let editingDidEndEvents: [UIControl.Event] = [.editingDidEnd, .editingDidEndOnExit]

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        sut = SUT()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // MARK: - Test init

    func test_emptyInit_setsText_toEmptyString() {
        let sut = SUT()
        XCTAssertEqual(sut.text, .empty)
    }

    func test_emptyInit_doesNotCreateMemoryLeaks() throws {
        weak var sut = self.sut
        self.sut = nil
        XCTAssertNil(sut)
    }

    // MARK: - Test allowing negative numbers

    func test_allowsNegativeNumbers_whenFalse_trimsMinus() {
        sut.allowsNegativeNumbers = false
        sut.text = negativeIntegerText
        XCTAssertEqual(sut.text, integerText)
    }

    func test_allowsNegativeNumbers_whenChangedToFalseAfterInput_trimsMinus() {
        sut.text = negativeIntegerText
        sut.allowsNegativeNumbers = false
        XCTAssertEqual(sut.text, integerText)
    }

    func test_allowsNegativeNumbers_whenTrue_keepsMinus() {
        sut.allowsNegativeNumbers = true
        sut.text = negativeIntegerText
        XCTAssertEqual(sut.text, negativeIntegerText)
    }

    func test_allowsNegativeNumbers_byDefault_isTrue() {
        XCTAssertTrue(sut.allowsNegativeNumbers)
    }

    // MARK: - Test resetting to zero

    func test_editingDidEnd_whenTextIsEmpty_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = .empty
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_whenTextIsNil_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = nil
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withZeroAndFloatingPoint_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "0."
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withFloatingPointZero_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "0.0"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withMultibleDigitFloatingPointZero_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "0.000"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withFloatingPoint_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "."
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withMinusAndFloatingPoint_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "-."
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withMinusZero_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "-0"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withMinusFloatingPointZero_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "-0.0"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    func test_editingDidEnd_withMinusZeroAndFloatingPoint_setsToZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "-0."
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, .zero)
        }
    }

    // MARK: - Test clearing

    func test_isClearingZeroWhenEditingBegins_byDefault_returnsTrue() {
        XCTAssertTrue(sut.isClearingZeroWhenEditingBegins)
    }

    func test_editingDidBegin_withZero_clearsTheText() {
        sut.text = .zero
        sut.sendActions(for: .editingDidBegin)
        XCTAssertEqual(sut.text, .empty)
    }

    func test_editingDidBegin_whenIsClearingZeroWhenEditingBeginsIsFalse_keepsZero() {
        sut.isClearingZeroWhenEditingBegins = false
        sut.text = .zero
        sut.sendActions(for: .editingDidBegin)
        XCTAssertEqual(sut.text, .zero)
    }

    func test_editingDidEnd_withOnlyZeroInFractionalPart_clearsZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "85.0"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, "85")
        }
    }

    func test_editingDidEnd_withZeroAfterFractionPart_clearsLastZero() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "1.05020"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, "1.0502")
        }
    }

    func test_editingDidEnd_withZeroAtTheBeginningOfIntegerPart_clearsZeroPrefix() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "02.035"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, "2.035")
        }
    }

    func test_editingDidEnd_withZeroAtTheBeginningOfNegativeIntegerPart_clearsZeroPrefix() {
        editingDidEndEvents.forEach { editingDidEndEvent in
            sut.text = "-03.047"
            sut.sendActions(for: editingDidEndEvent)
            XCTAssertEqual(sut.text, "-3.047")
        }
    }

    // MARK: - Test input

    func test_input_withCommna_replacesCommaWithDot() {
        sut.text = "0,0"
        XCTAssertEqual(sut.text, "0.0")
    }

    func test_input_allowsOnlyOneFroatingPoint() {
        sut.text = "1.3.0.5"
        XCTAssertEqual(sut.text, "1.305")
    }

    func test_input_withMixedSymbols_keepsOnlyAllowedSymbols() {
        sut.text = "hell0wor1d!"
        XCTAssertEqual(sut.text, "01")
    }

    func test_input_whenNotEndedYet_allowsUntrimmedInput() {
        let untrimmedInput = "00000.10000"
        sut.text = untrimmedInput
        XCTAssertEqual(sut.text, untrimmedInput)
    }

    func test_input_whenNotEndedYet_allowsFloatingPointEnding() {
        let input = "-28."
        sut.text = input
        XCTAssertEqual(sut.text, input)
    }
}
