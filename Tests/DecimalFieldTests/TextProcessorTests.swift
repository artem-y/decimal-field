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
    private let allDigits = "1234567890"
    private let negativeInteger = "-123"

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
        XCTAssertEqual(sut.process(allDigits), allDigits)
    }

    func test_process_floatingPointNumber_keepsFloatingPoint() {
        let floatText = "3.15"
        XCTAssertEqual(sut.process(floatText), floatText)
    }

    func test_process_negativeInteger_keepsNegativeInteger() {
        XCTAssertEqual(sut.process(negativeInteger), negativeInteger)
    }

    func test_process_dashInTheMiddle_removesDash() {
        XCTAssertEqual(sut.process("2-1"), "21")
    }
}
