import XCTest
@testable import DecimalField

final class DecimalFieldTests: XCTestCase {
    typealias SUT = DecimalField

    func test_emptyInit_setsText_toEmptyString() throws {
        let sut = SUT()
        XCTAssertEqual(sut.text, String())
    }
}
