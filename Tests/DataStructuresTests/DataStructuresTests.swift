import XCTest
@testable import DataStructures

class DataStructuresTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(DataStructures().text, "Hello, World!")
    }


    static var allTests : [(String, (DataStructuresTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
