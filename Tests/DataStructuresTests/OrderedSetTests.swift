import XCTest
@testable import DataStructures

class OrderedSetTests: XCTestCase {
    static var allTests : [(String, (OrderedSetTests) -> () throws -> Void)] {
        return [
            ("testEmptyInitialization", testEmptyInitialization),
            ("testInitializationWithElement", testInitializationWithElement),
            ("testInitializationWithElements", testInitializationWithElements),
            ("testEquality", testEquality),
            ("testForIn", testForIn),
            ("testMap", testMap),
            ("testAppendElement", testAppendElement),
            ("testAppendElements", testAppendElements),
            ("testInsertElements", testInsertElements),
            ("testSubscript", testSubscript),
            ("testRemoveElement", testRemoveElement),
            ("testRemoveElements", testRemoveElements),
            ("testRemoveAt", testRemoveAt),
            ("testReversed", testReversed),
            ("testSetInsert", testSetInsert),
            ("testSetUpdate", testSetUpdate),
            ("testSetRemove", testSetRemove),
            ("testIntersection", testIntersection),
            ("testUnion", testUnion),
            ("testSymmetricDifference", testSymmetricDifference),
            ("testArrayAccessPerformance", testArrayAccessPerformance),
            ("testNSOrderedSetAccessPerformance", testNSOrderedSetAccessPerformance),
            ("testOrderedSetAccessPerformance", testOrderedSetAccessPerformance),
            ("testArrayAppendPerformance", testArrayAppendPerformance),
            ("testNSOrderedSetAppendPerformance", testNSOrderedSetAppendPerformance),
            ("testOrderedSetAppendPerformance", testOrderedSetAppendPerformance),
            ("testArrayPrependPerformance", testArrayPrependPerformance),
            ("testNSOrderedSetPrependPerformance", testNSOrderedSetPrependPerformance),
            ("testOrderedSetPrependPerformance", testOrderedSetPrependPerformance),
        ]
    }

    func testEmptyInitialization() {
        let orderedSet = OrderedSet<Int>()
        _assert(orderedSet, equals: [])
    }

    func testInitializationWithElement() {
        let orderedSet = OrderedSet<Int>(1)
        _assert(orderedSet, equals: [1])
    }

    func testInitializationWithElements() {
        let orderedSet = OrderedSet([0, 2, 4, 6, 200000])
        _assert(orderedSet, equals: [0, 2, 4, 6, 200000])
    }

    func testEquality() {
        var one = OrderedSet<Int>()
        var two = OrderedSet<Int>()
        XCTAssertEqual(one, two)

        one.append(123)
        XCTAssertNotEqual(one, two)

        two.insert(123, at: 0)
        XCTAssertEqual(one, two)

        one.insert(0, at: 0)
        two.insert(0, at: 1)
        XCTAssertNotEqual(one, two)

        one.insert(0, at: 2)
        XCTAssertEqual(one, two)

        one.remove(at: 0)
        XCTAssertNotEqual(one, two)

        two.remove(123)
        XCTAssertEqual(one, two)
    }

    func testForIn() {
        var input = [0, 2, 4, 6, 200000]
        let orderedSet = OrderedSet(input)

        for integer in orderedSet {
            XCTAssertEqual(input.first, integer)
            input.remove(at: 0)
        }

        XCTAssertEqual(input, [])
    }

    func testMap() {
        let orderedSet = OrderedSet(["one", "two", "three"])
        _assert(orderedSet, equals: ["one", "two", "three"])

        let expected = ["ONE", "TWO", "THREE"]
        let output = orderedSet.map { $0.uppercased() }

        XCTAssertEqual(expected, output)
    }

    func testAppendElement() {
        var orderedSet = OrderedSet<Int>()
        _assert(orderedSet, equals: [])
        orderedSet.append(123)
        _assert(orderedSet, equals: [123])
    }

    func testAppendElements() {
        var orderedSet = OrderedSet<Int>()
        _assert(orderedSet, equals: [])

        orderedSet.append(123)
        _assert(orderedSet, equals: [123])

        orderedSet.append(0)
        _assert(orderedSet, equals: [123, 0])

        orderedSet.append(5)
        _assert(orderedSet, equals: [123, 0, 5])
    }

    func testInsertElements() {
        var orderedSet = OrderedSet([123, 0, 5])
        _assert(orderedSet, equals: [123, 0, 5])

        orderedSet.insert(4, at: 0)
        _assert(orderedSet, equals: [4, 123, 0, 5])

        orderedSet.insert(124, at: 2)
        _assert(orderedSet, equals: [4, 123, 124, 0, 5])

        orderedSet.insert(888, at: 5)
        _assert(orderedSet, equals: [4, 123, 124, 0, 5, 888])

        orderedSet.insert(0, at: 2)
        _assert(orderedSet, equals: [4, 123, 0, 124, 5, 888])

        orderedSet.insert(0, at: 2)
        _assert(orderedSet, equals: [4, 123, 0, 124, 5, 888])

        orderedSet.insert(0, at: 5)
        _assert(orderedSet, equals: [4, 123, 124, 5, 0, 888])

        orderedSet.insert(0, at: 6)
        _assert(orderedSet, equals: [4, 123, 124, 5, 888, 0])
    }

    func testSubscript() {
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        _assert(orderedSet, equals: ["abc", "123", "def", "456"])

        XCTAssertEqual("abc", orderedSet[0])
        XCTAssertEqual("456", orderedSet[3])

        orderedSet[3] = "new"
        XCTAssertFalse(orderedSet.contains("456"))
        _assert(orderedSet, equals: ["abc", "123", "def", "new"])

        orderedSet[1] = "another new"
        XCTAssertFalse(orderedSet.contains("123"))
        _assert(orderedSet, equals: ["abc", "another new", "def", "new"])
    }

    func testRemoveElement() {
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        _assert(orderedSet, equals: ["abc", "123", "def", "456"])

        orderedSet.remove("123")
        _assert(orderedSet, equals: ["abc", "def", "456"])
    }

    func testRemoveElements() {
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        _assert(orderedSet, equals: ["abc", "123", "def", "456"])

        orderedSet.remove("123")
        _assert(orderedSet, equals: ["abc", "def", "456"])

        orderedSet.remove("456")
        _assert(orderedSet, equals: ["abc", "def"])

        orderedSet.remove("abc")
        _assert(orderedSet, equals: ["def"])

        orderedSet.remove("abc")
        _assert(orderedSet, equals: ["def"])

        orderedSet.remove("def")
        _assert(orderedSet, equals: [])
    }

    func testRemoveAt() {
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        _assert(orderedSet, equals: ["abc", "123", "def", "456"])

        orderedSet.remove(at: 0)
        _assert(orderedSet, equals: ["123", "def", "456"])

        orderedSet.remove(at: 2)
        _assert(orderedSet, equals: ["123", "def"])

        orderedSet.remove(at: 0)
        _assert(orderedSet, equals: ["def"])

        orderedSet.remove(at: 0)
        _assert(orderedSet, equals: [])
    }

    func testReversed() {
        let orderedSet = OrderedSet([0, 2, 4, 6, 200000])
        _assert(orderedSet, equals: [0, 2, 4, 6, 200000])

        let reversed = orderedSet.reversed()
        _assert(reversed, equals: [200000, 6, 4, 2, 0])
    }

    func testSetInsert() {
        var set = Set(["abc", "123", "def", "456"])
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput1 = set.insert("123")
        let orderedSetOutput1 = orderedSet.insert("123")
        XCTAssertEqual(setOutput1.inserted, orderedSetOutput1.inserted)
        XCTAssertEqual(setOutput1.memberAfterInsert, orderedSetOutput1.memberAfterInsert)
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput2 = set.insert("doesn't exist")
        let orderedSetOutput2 = orderedSet.insert("doesn't exist")
        XCTAssertEqual(setOutput2.inserted, orderedSetOutput2.inserted)
        XCTAssertEqual(setOutput2.memberAfterInsert, orderedSetOutput2.memberAfterInsert)
        XCTAssertEqual(set.count, orderedSet.count)
    }

    func testSetUpdate() {
        var set = Set(["abc", "123", "def", "456"])
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput1 = set.update(with: "123")
        let orderedSetOutput1 = orderedSet.update(with: "123")
        XCTAssertEqual(setOutput1, orderedSetOutput1)
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput2 = set.update(with: "doesn't exist")
        let orderedSetOutput2 = orderedSet.update(with: "doesn't exist")
        XCTAssertEqual(setOutput2, orderedSetOutput2)
        XCTAssertEqual(set.count, orderedSet.count)
    }

    func testSetRemove() {
        var set = Set(["abc", "123", "def", "456"])
        var orderedSet = OrderedSet(["abc", "123", "def", "456"])
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput1 = set.remove("123")
        let orderedSetOutput1 = orderedSet.remove("123")
        XCTAssertEqual(setOutput1, orderedSetOutput1)
        XCTAssertEqual(set.count, orderedSet.count)

        let setOutput2 = set.remove("doesn't exist")
        let orderedSetOutput2 = orderedSet.remove("doesn't exist")
        XCTAssertEqual(setOutput2, orderedSetOutput2)
        XCTAssertEqual(set.count, orderedSet.count)
    }

    func testIntersection() {
        let initial = OrderedSet(["Alicia", "Bethany", "Chris", "Diana", "Eric"])
        let other = OrderedSet(["Bethany", "Eric", "Forlani", "Greta"])

        var mutable = initial
        mutable.formIntersection(other)

        let immutable = initial.intersection(other)

        XCTAssertEqual(mutable, immutable)
        _assert(mutable, equals: ["Bethany", "Eric"])
        _assert(immutable, equals: ["Bethany", "Eric"])
    }

    func testUnion() {
        let initial = OrderedSet(["Alicia", "Bethany", "Diana", "Eric"])
        let other = OrderedSet(["Marcia", "Nathaniel", "Eric"])

        var mutable = initial
        mutable.formUnion(other)

        let immutable = initial.union(other)

        XCTAssertEqual(mutable, immutable)
        _assert(mutable, equals: ["Alicia", "Bethany", "Diana", "Eric", "Marcia", "Nathaniel"])
        _assert(immutable, equals: ["Alicia", "Bethany", "Diana", "Eric", "Marcia", "Nathaniel"])
    }

    func testSymmetricDifference() {
        let initial = OrderedSet(["Alicia", "Bethany", "Chris", "Diana", "Eric"])
        let other = OrderedSet(["Bethany", "Eric", "Forlani", "Greta"])

        var mutable = initial
        mutable.formSymmetricDifference(other)

        let immutable = initial.symmetricDifference(other)

        XCTAssertEqual(mutable, immutable)
        _assert(mutable, equals: ["Alicia", "Chris", "Diana", "Forlani", "Greta"])
        _assert(immutable, equals: ["Alicia", "Chris", "Diana", "Forlani", "Greta"])
    }

    // 0.092 seconds when _inputCount == 1000
    func testArrayAccessPerformance() {
        let input = _integerArray(count: _inputCount)
        let sorted = input.sorted()

        var indexes = Array<Int>()
        indexes.reserveCapacity(input.count)

        var iterations = 0

        measure {
            iterations += 1
            for integer in sorted {
                indexes.append(input.index(of: integer)!)
            }
        }

        XCTAssertEqual(input.count, indexes.count / iterations)
    }

    // 0.001 seconds when _inputCount == 1000
    func testNSOrderedSetAccessPerformance() {
        let input = _numberArray(count: _inputCount)
        let sorted = input.sorted { $0.compare($1) == .orderedAscending }

        let nsOrderedSet = NSOrderedSet(array: input)

        var indexes = Array<Int>()
        indexes.reserveCapacity(input.count)

        var iterations = 0

        measure {
            iterations += 1
            for integer in sorted {
                indexes.append(nsOrderedSet.index(of: integer))
            }
        }

        XCTAssertEqual(input.count, indexes.count / iterations)
    }

    // 0.000 seconds when _inputCount == 1000
    func testOrderedSetAccessPerformance() {
        let input = _integerArray(count: _inputCount)
        let sorted = input.sorted()

        let orderedSet = OrderedSet(input)

        var indexes = Array<Int>()
        indexes.reserveCapacity(input.count)

        var iterations = 0

        measure {
            iterations += 1
            for integer in sorted {
                indexes.append(orderedSet.index(of: integer)!)
            }
        }

        XCTAssertEqual(input.count, indexes.count / iterations)
    }

    // 0.055 seconds when _inputCount == 1000
    func testArrayRemovePerformance() {
        let input = _integerArray(count: _inputCount)
        let sorted = input.sorted()

        measure {
            var mutable = input
            for integer in sorted {
                guard let index = mutable.index(of: integer) else { XCTFail(); continue }
                mutable.remove(at: index)
            }
            XCTAssertEqual(0, mutable.count)
        }
    }

    // 0.002 seconds when _inputCount == 1000
    func testNSOrderedSetRemovePerformance() {
        let input = _numberArray(count: _inputCount)
        let sorted = input.sorted { $0.compare($1) == .orderedAscending }

        let nsOrderedSet = NSOrderedSet(array: input)

        measure {
            let mutable = NSMutableOrderedSet(orderedSet: nsOrderedSet)
            for number in sorted {
                mutable.remove(number)
            }
            XCTAssertEqual(0, mutable.count)
        }
    }

    // 0.147 seconds when _inputCount == 1000
    func testOrderedSetRemovePerformance() {
        let input = _integerArray(count: _inputCount)
        let sorted = input.sorted()

        let orderedSet = OrderedSet(input)

        measure {
            var mutable = orderedSet
            for integer in sorted {
                mutable.remove(integer)
            }
            XCTAssertEqual(0, mutable.count)
        }
    }

    // 0.000 seconds when _inputCount == 1000
    func testArrayAppendPerformance() {
        let input = _integerArray(count: _inputCount)

        var array = Array<Int>()

        measure {
            for integer in input {
                array.append(integer)
            }
        }
    }

    // 0.000 seconds when _inputCount == 1000
    func testNSOrderedSetAppendPerformance() {
        let input = _numberArray(count: _inputCount)

        let nsOrderedSet = NSMutableOrderedSet()

        measure {
            for number in input {
                nsOrderedSet.add(number)
            }
        }
    }

    // 0.501 seconds when _inputCount == 1000
    func testOrderedSetAppendPerformance() {
        let input = _integerArray(count: _inputCount)

        var orderedSet = OrderedSet<Int>()

        measure {
            for integer in input {
                orderedSet.append(integer)
            }
        }
    }

    // 0.003 seconds when _inputCount == 1000
    func testArrayPrependPerformance() {
        let input = _integerArray(count: _inputCount)

        var array = Array<Int>()

        measure {
            for integer in input {
                array.insert(integer, at: 0)
            }
        }
    }

    // 0.001 seconds when _inputCount == 1000
    func testNSOrderedSetPrependPerformance() {
        let input = _numberArray(count: _inputCount)

        let nsOrderedSet = NSMutableOrderedSet()

        measure {
            for number in input {
                nsOrderedSet.insert(number, at: 0)
            }
        }
    }

    // 0.537 seconds when _inputCount == 1000
    func testOrderedSetPrependPerformance() {
        let input = _integerArray(count: _inputCount)

        var orderedSet = OrderedSet<Int>()

        measure {
            for integer in input {
                orderedSet.insert(integer, at: 0)
            }
        }
    }
}

extension OrderedSetTests {
    fileprivate func _assert<T: Hashable>(_ orderedSet: OrderedSet<T>, equals expected: Array<T>) {
        XCTAssertEqual(expected.count, orderedSet.count)
        XCTAssertEqual(expected.first, orderedSet.first)
        XCTAssertEqual(expected.last, orderedSet.last)
        for (index, element) in expected.enumerated() {
            XCTAssert(orderedSet.contains(element))
            XCTAssertEqual(element, orderedSet[index])
            XCTAssertEqual(index, orderedSet.index(of: element))
        }
    }
}

extension OrderedSetTests {
    fileprivate var _inputCount: Int { return 1000 }

    fileprivate func _numberArray(count: Int) -> Array<NSNumber> {
        return _integerArray(count: count).map { NSNumber(value: $0) }
    }

    fileprivate func _integerArray(count: Int) -> Array<Int> {
        return (0..<count).map { _ in return Int(arc4random()) }
    }
}
