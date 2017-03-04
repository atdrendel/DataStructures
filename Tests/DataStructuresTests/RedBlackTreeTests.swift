import XCTest
@testable import DataStructures

class RedBlackTreeTests: XCTestCase {
    static var allTests : [(String, (RedBlackTreeTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
            ("testIsEmpty", testIsEmpty),
            ("testCount", testCount),
            ("testElements", testElements),
            ("testInsertIntegers", testInsertIntegers),
            ("testInsertDuplicateIntegers", testInsertDuplicateIntegers),
            ("testInsertRandomIntegers", testInsertRandomIntegers),
        ]
    }

    func testInit() {
        let tree = RedBlackTree<Int>()
        XCTAssertNotNil(tree)
        XCTAssertTrue(tree.isEmpty)
    }

    func testIsEmpty() {
        let empty = RedBlackTree<Int>.empty
        let notEmpty = RedBlackTree.node(color: .red, left: .empty, element: 1, right: .empty)
        XCTAssertTrue(empty.isEmpty)
        XCTAssertFalse(notEmpty.isEmpty)
    }

    func testCount() {
        let integers = randomIntegers()
        let tree = RedBlackTree(integers)
        XCTAssertEqual(integers.count, tree.count)
    }

    func testElements() {
        let integers = randomIntegers()
        let sorted = integers.sorted()

        let tree = RedBlackTree(integers)
        XCTAssertEqual(sorted, tree.elements)
    }

    func testInsertIntegers() {
        let integers = [8, 1, 4]
        let sorted = integers.sorted()

        let tree = RedBlackTree(integers)
        var count = 0
        for (index, integer) in tree.enumerated() {
            XCTAssertEqual(sorted[index], integer)
            count += 1
        }
        XCTAssertEqual(integers.count, count)
    }

    func testInsertDuplicateIntegers() {
        let integers = [8, 1, 4, 8, 1, 4]
        let tree = RedBlackTree(integers)

        for (index, integer) in tree.enumerated() {
            switch index {
            case 0:
                XCTAssertEqual(1, integer)
            case 1:
                XCTAssertEqual(4, integer)
            case 2:
                XCTAssertEqual(8, integer)
            default:
                XCTFail("There should be no duplicates inside of \(tree)")
            }
        }
    }

    func testInsertRandomIntegers() {
        let integers = randomIntegers()
        let sorted = integers.sorted()

        let tree = RedBlackTree(integers)
        for (index, integer) in tree.enumerated() {
            XCTAssertEqual(sorted[index], integer)
        }
    }
}

extension RedBlackTreeTests {
    func randomIntegers(count: Int = 1000) -> Array<Int> {
        let random = (0..<count).map { (_) in return Int(arc4random_uniform(100000)) }
        var added = Set<Int>()
        return random.filter({ (integer) -> Bool in
            if added.contains(integer) {
                return false
            } else {
                added.insert(integer)
                return true
            }
        })
    }
}
