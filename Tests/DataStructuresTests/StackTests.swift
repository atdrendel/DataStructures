import XCTest
@testable import DataStructures

class StackTests: XCTestCase {
    static var allTests : [(String, (StackTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
        ]
    }

    func testInit() {
        let stack = Stack()
    }
}
