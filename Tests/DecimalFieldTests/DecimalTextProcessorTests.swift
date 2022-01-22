//
//  DecimalTextProcessorTests.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import XCTest
@testable import DecimalField

final class DecimalTextProcessorTests: XCTestCase {
    typealias SUT = DecimalTextProcessor

    private var sut: SUT!

    // MARK: - Lifecycle

    override func setUp() {
        sut = SUT()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: - Test process

    func test_process_emptyText_returnsEmptyText() {
        XCTAssertEqual(sut.process(.empty), .empty)
    }

    func test_process_letters_returnsEmptyText() {
        XCTAssertEqual(sut.process("ZeroOneTwoThree"), .empty)
    }

    func test_process_digits_returnsDigits() {
        let allDigits = "1234567890"
        XCTAssertEqual(sut.process(allDigits), allDigits)
    }

    func test_process_floatingPointNumber_keepsFloatingPoint() {
        let floatText = "3.15"
        XCTAssertEqual(sut.process(floatText), floatText)
    }

    func test_process_negativeInteger_keepsMinus() {
        let negativeInteger = "-321"
        XCTAssertEqual(sut.process(negativeInteger), negativeInteger)
    }

    func test_process_onlyMinus_keepsMinus() {
        XCTAssertEqual(sut.process("-"), "-")
    }

    func test_process_negativeIntegerWithOtherSymbols_keepsNegativeInteger() {
        XCTAssertEqual(sut.process("abc -935z"), "-935")
    }

    func test_process_dashInTheMiddle_removesDash() {
        XCTAssertEqual(sut.process("2-1"), "21")
    }

    func test_process_dashAtTheEnd_removesDash() {
        XCTAssertEqual(sut.process("5-"), "5")
    }

    func test_process_allowsOnlyOneFloatingPoint() {
        XCTAssertEqual(sut.process("71.2.0.3"), "71.203")
    }

    func test_process_singleFloatingPoint_addsZeroPrefix() {
        XCTAssertEqual(sut.process("."), "0.")
    }

    func test_process_textWithComma_replacesCommaWithDot() {
        XCTAssertEqual(sut.process("82,6"), "82.6")
    }

    // MARK: - Test allowsNegativeNumbers

    func test_allowsNegativeNumbers_whenFalse_trimsMinus() {
        sut = SUT(allowsNegativeNumbers: false)
        XCTAssertEqual(sut.process("-783"), "783")
    }

    func test_allowsNegativeNumbers_whenFalse_removesUnattachedMinus() {
        sut = SUT(allowsNegativeNumbers: false)
        XCTAssertEqual(sut.process("- 125"), "125")
    }

    // MARK: - Test makeNonEmptyTrimmedText

    func test_makeNonEmptyTrimmedText_whenNothingToTrim_doesNotTrim() {
        let text = "851"
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: text), text)
    }

    func test_makeNonEmptyTrimmedText_fromEmptyText_returnsZero() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: .empty), .zero)
    }

    func test_makeNonEmptyTrimmedText_fromFloatingPoint_returnsZero() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "."), .zero)
    }

    func test_makeNonEmptyTrimmedText_fromNegativeZeroFloat_returnsZero() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "-0.0"), .zero)
    }

    func test_makeNonEmptyTrimmedText_fromIntegerStartingWithZero_trimsZero() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "01"), "1")
    }

    func test_makeNonEmptyTrimmedText_fromNegativeInteger_doesNotTrim() {
        let text = "-31"
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: text), text)
    }

    func test_makeNonEmptyTrimmedText_fromNegativeIntegerStartingWithZero_trimsZero() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "-01"), "-1")
    }

    func test_makeNonEmptyTrimmedText_fromIntegerEndingWithZero_doesNotTrimZeroEnding() {
        let text = "31500"
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: text), text)
    }

    func test_makeNonEmptyTrimmedText_fromFloatEndingWithZero_trimsZeroEnding() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "2.0850"), "2.085")
    }

    func test_makeNonEmptyTrimmedText_fromFloatWithExtraZeros_trimsExtraZeros() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "00.350"), "0.35")
    }

    func test_makeNonEmptyTrimmedText_fromFloatWithoutFraction_keepsOnlyIntegerPart() {
        XCTAssertEqual(sut.makeNonEmptyTrimmedText(from: "30.0"), "30")
    }
}
