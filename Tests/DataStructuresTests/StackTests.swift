import XCTest
@testable import DataStructures

class StackTests: XCTestCase {
    static var allTests : [(String, (StackTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
            ("testPushAndPopInts", testPushAndPopInts),
            ("testPushAndPopStrings", testPushAndPopStrings),
            ("testDescription", testDescription),
        ]
    }

    func testInit() {
        var stack = Stack<Int>()
        XCTAssertNotNil(stack)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peek())
        XCTAssertNil(stack.pop())
    }

    func testPushAndPopInts() {
        var stack = Stack<Int>()
        XCTAssertEqual(0, stack.count)

        stack.push(1)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(1, stack.peek()!)

        stack.push(2)
        XCTAssertEqual(2, stack.count)
        XCTAssertEqual(2, stack.peek()!)

        XCTAssertEqual(2, stack.pop()!)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(1, stack.peek()!)

        XCTAssertEqual(1, stack.pop()!)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peek())

        XCTAssertNil(stack.pop())
        XCTAssertNil(stack.peek())
    }

    func testPushAndPopStrings() {
        var stack = Stack<String>()
        XCTAssertEqual(0, stack.count)

        stack.push("1")
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual("1", stack.peek()!)

        stack.push("2")
        XCTAssertEqual(2, stack.count)
        XCTAssertEqual("2", stack.peek()!)

        XCTAssertEqual("2", stack.pop()!)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual("1", stack.peek()!)

        XCTAssertEqual("1", stack.pop()!)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peek())

        XCTAssertNil(stack.pop())
        XCTAssertNil(stack.peek())
    }

    func testDescription() {
        var stack = Stack<String>()
        stack.push("1")
        stack.push("2")

        let descWith2 = "Stack {\n\t2,\n\t1,\n}"
        XCTAssertEqual(descWith2, stack.description)
    }
}
