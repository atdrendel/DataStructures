import XCTest
@testable import DataStructures

class StackTests: XCTestCase {
    static var allTests : [(String, (StackTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
            ("testInitWithElement", testInitWithElement),
            ("testPushAndPopInts", testPushAndPopInts),
            ("testPushAndPopStrings", testPushAndPopStrings),
            ("testForEach", testForEach),
            ("testForEachThrows", testForEachThrows),
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

    func testInitWithElement() {
        let value = 123
        let stack = Stack(value)
        XCTAssertNotNil(stack)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(value, stack.peek())
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

    func testForEach() {
        class Object {
            var value: Int = 0
        }

        let one = Object()
        let two = Object()
        let three = Object()

        var stack = Stack<Object>()
        stack.push(one)
        stack.push(two)
        stack.push(three)

        stack.forEach { $0.value += 1 }
        XCTAssertEqual(1, one.value)
        XCTAssertEqual(1, two.value)
        XCTAssertEqual(1, three.value)
    }

    func testForEachThrows() {
        struct ObjectError: Error { }

        class Object {
            var value: Int = 0

            func increment(throw: Bool) throws {
                if `throw` { throw ObjectError() }
                else { value += 1 }
            }
        }

        let one = Object()
        let two = Object()

        var stack = Stack<Object>()
        stack.push(one)
        stack.push(two)

        XCTAssertThrowsError(try stack.forEach({ try $0.increment(throw: true) })) { error in
            XCTAssertTrue(error is ObjectError)
        }

        XCTAssertEqual(0, one.value)
        XCTAssertEqual(0, two.value)
    }

    func testDescription() {
        var stack = Stack<String>()
        stack.push("1")
        stack.push("2")

        let descWith2 = "Stack {\n\t2,\n\t1,\n}"
        XCTAssertEqual(descWith2, stack.description)
    }
}
