//
//  TextProcessorTests.swift
//  
//
//  Created by Artem Yelizarov on 20.01.2022.
//

import XCTest
@testable import DecimalField

final class TextProcessorTests: XCTestCase {
    typealias SUT = DecimalField.TextProcessor

    private var sut: SUT!

    // MARK: - Lifecycle

    override func setUp() {
        sut = SUT()
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: - Tests

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

    func test_allowsNegativeNumbers_whenFalse_trimsMinus() {
        sut = SUT(allowsNegativeNumbers: false)
        XCTAssertEqual(sut.process("-783"), "783")
    }

    func test_allowsNegativeNumbers_whenFalse_removesUnattachedMinus() {
        sut = SUT(allowsNegativeNumbers: false)
        XCTAssertEqual(sut.process("- 125"), "125")
    }

    func test_process_textWithComma_replacesCommaWithDot() {
        XCTAssertEqual(sut.process("82,6"), "82.6")
    }
}
