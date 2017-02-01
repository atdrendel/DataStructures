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
            ("testForEachUsesReversedOrder", testForEachUsesReversedOrder),
            ("testElementWhere", testElementWhere),
            ("testStacksWithEquatableElementsAreEquatable", testStacksWithEquatableElementsAreEquatable),
            ("testDescription", testDescription),
        ]
    }

    func testInit() {
        var stack = Stack<Int>()
        XCTAssertNotNil(stack)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peekAtTop())
        XCTAssertNil(stack.peekAtBottom())
        XCTAssertNil(stack.peek(at: 0))
        XCTAssertNil(stack.pop())
    }

    func testInitWithElement() {
        let value = 123
        let stack = Stack(value)
        XCTAssertNotNil(stack)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(value, stack.peekAtTop())
        XCTAssertEqual(value, stack.peekAtBottom())
        XCTAssertEqual(value, stack.peek(at: 0))
    }

    func testPushAndPopInts() {
        var stack = Stack<Int>()
        XCTAssertEqual(0, stack.count)

        stack.push(1)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(1, stack.peekAtTop()!)
        XCTAssertEqual(1, stack.peekAtBottom()!)
        XCTAssertEqual(1, stack.peek(at: 0))

        stack.push(2)
        XCTAssertEqual(2, stack.count)
        XCTAssertEqual(2, stack.peekAtTop()!)
        XCTAssertEqual(1, stack.peekAtBottom()!)
        XCTAssertEqual(2, stack.peek(at: 1))

        XCTAssertEqual(2, stack.pop()!)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual(1, stack.peekAtTop()!)
        XCTAssertEqual(1, stack.peekAtBottom()!)
        XCTAssertNil(stack.peek(at: 1))

        XCTAssertEqual(1, stack.pop()!)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peekAtTop())
        XCTAssertNil(stack.peekAtBottom())

        XCTAssertNil(stack.pop())
        XCTAssertNil(stack.peekAtTop())
        XCTAssertNil(stack.peekAtBottom())
    }

    func testPushAndPopStrings() {
        var stack = Stack<String>()
        XCTAssertEqual(0, stack.count)

        stack.push("1")
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual("1", stack.peekAtTop()!)

        stack.push("2")
        XCTAssertEqual(2, stack.count)
        XCTAssertEqual("2", stack.peekAtTop()!)

        XCTAssertEqual("2", stack.pop()!)
        XCTAssertEqual(1, stack.count)
        XCTAssertEqual("1", stack.peekAtTop()!)

        XCTAssertEqual("1", stack.pop()!)
        XCTAssertEqual(0, stack.count)
        XCTAssertNil(stack.peekAtTop())

        XCTAssertNil(stack.pop())
        XCTAssertNil(stack.peekAtTop())
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

    func testForEachUsesReversedOrder() {
        struct Object {
            let value: Int

            static func == (lhs: Object, rhs: Object) -> Bool {
                return lhs.value == rhs.value
            }
        }

        let first = Object(value: 2)
        let second = Object(value: 1)
        let third = Object(value: 0)

        var stack = Stack<Object>()
        stack.push(first)
        stack.push(second)
        stack.push(third)

        var index = 0
        stack.forEach { (object) in
            XCTAssertEqual(index, object.value)
            index += 1
        }
    }

    func testElementWhere() {
        class Object {
            let value: Int

            init(value: Int) {
                self.value = value
            }

            static func == (lhs: Object, rhs: Object) -> Bool {
                return lhs.value == rhs.value
            }
        }

        let first = Object(value: 1)
        let second = Object(value: 1)
        let third = Object(value: 2)

        var stack = Stack<Object>()
        stack.push(first)
        stack.push(second)
        stack.push(third)

        let element = stack.element { (element) -> Bool in
            element.value == 1
        }

        XCTAssertNotNil(element)
        XCTAssertTrue(element! === second)
        XCTAssertTrue(element! !== first) // Make sure the test happens in reverse order
    }

    func testStacksWithEquatableElementsAreEquatable() {
        var target = Stack<Int>()
        target.push(1)
        target.push(2)
        target.push(3)

        let equal = target
        XCTAssertTrue(target == equal)

        var notEqual = target
        notEqual.pop()
        XCTAssertFalse(target == notEqual)
    }

    func testDescription() {
        var stack = Stack<String>()
        stack.push("1")
        stack.push("2")

        let descWith2 = "Stack {\n\t2,\n\t1,\n}"
        XCTAssertEqual(descWith2, stack.description)
    }
}
