import Foundation

public struct OrderedSet<Element: Hashable> {
    fileprivate var _array = Array<Element>()
    fileprivate var _dictionary = Dictionary<Element, Int>()

    public init() { }

    public init(_ element: Element) {
        _append(element)
    }

    public init<S: Sequence>(_ elements: S) where S.Iterator.Element == Element {
        elements.forEach { _append($0) }
    }

    fileprivate mutating func _append(_ element: Element) {
        _remove(element)
        let index = _array.count
        _array.append(element)
        _dictionary[element] = index
    }

    fileprivate mutating func _insert(_ element: Element, at index: Int) {
        let removedAt = _remove(element)

        let insertAt: Int
        if let removedAt = removedAt {
            insertAt = removedAt < index ? index - 1 : index
        } else {
            insertAt = index
        }

        _array.insert(element, at: insertAt)
        _dictionary[element] = insertAt
        _reindex(from: (insertAt + 1))
    }

    @discardableResult fileprivate mutating func _remove(_ element: Element) -> Int? {
        guard let index = _dictionary[element] else { return nil }
        _dictionary.removeValue(forKey: element)
        _array.remove(at: index)
        _reindex(from: index)
        return index
    }

    private mutating func _reindex(from index: Int) {
        let count = _array.count
        guard index < count else { return }
        let start = index
        for (index, element) in _array[start..<count].enumerated() {
            _dictionary[element] = start + index
        }
    }
}

extension OrderedSet {
    public var count: Int { return _array.count }

    public var first: Element? { return _array.first }
    public var last: Element? { return _array.last }

    public func reversed() -> OrderedSet<Element> {
        let reversed = _array.reversed()
        return OrderedSet(reversed)
    }

    public func index(of element: Element) -> Int? {
        return _dictionary[element]
    }

    public mutating func append(_ element: Element) {
        _append(element)
    }

    public mutating func insert(_ element: Element, at index: Int) {
        _insert(element, at: index)
    }

    @discardableResult public mutating func remove(at index: Int) -> Element {
        let element = _array[index]
        _remove(element)
        return element
    }
}

extension OrderedSet: Equatable {
    public static func == (lhs: OrderedSet<Element>, rhs: OrderedSet<Element>) -> Bool {
        return lhs._array == rhs._array
    }
}

extension OrderedSet: Sequence {
    public typealias Iterator = IndexingIterator<Array<Element>>

    public func makeIterator() -> Iterator {
        return _array.makeIterator()
    }
}

extension OrderedSet: Collection {
    public var startIndex: Int { return _array.startIndex }
    public var endIndex: Int { return _array.endIndex }

    public var isEmpty: Bool { return _array.isEmpty }

    public subscript(index: Int) -> Element {
        get { return _array[index] }
        set {
            let old = _array[index]
            _dictionary.removeValue(forKey: old)
            _array[index] = newValue
            _dictionary[newValue] = index
        }
    }

    public func index(after i: Int) -> Int {
        return _array.index(after: i)
    }
}

extension OrderedSet: SetAlgebra {
    public func contains(_ element: Element) -> Bool {
        return _dictionary[element] != nil
    }

    @discardableResult public mutating func insert(_ newMember: Element) ->
        (inserted: Bool, memberAfterInsert: Element) {
            let index = self.index(of: newMember)
            if let index = index {
                return (false, _array[index])
            } else {
                append(newMember)
                return (true, newMember)
            }
    }

    public mutating func update(with newMember: Element) -> Element? {
        if let index = self.index(of: newMember) {
            let previous = _array[index]
            _array[index] = newMember
            _dictionary[newMember] = index
            return previous
        } else {
            _append(newMember)
            return nil
        }
    }

    @discardableResult public mutating func remove(_ member: Element) -> Element? {
        if let index = self.index(of: member) {
            let removed = _array[index]
            _remove(member)
            return removed
        } else {
            return nil
        }
    }

    public func intersection(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
        var copy = self
        copy.formIntersection(other)
        return copy
    }

    public mutating func formIntersection(_ other: OrderedSet<Element>) {
        let copy = self
        for element in copy {
            if other.contains(element) == false {
                self.remove(element)
            }
        }
    }

    public func union(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
        var copy = self
        copy.formUnion(other)
        return copy
    }

    public mutating func formUnion(_ other: OrderedSet<Element>) {
        for otherElement in other {
            self.insert(otherElement)
        }
    }

    public func symmetricDifference(_ other: OrderedSet<Element>) -> OrderedSet<Element> {
        var copy = self
        copy.formSymmetricDifference(other)
        return copy
    }

    public mutating func formSymmetricDifference(_ other: OrderedSet<Element>) {
        for otherElement in other {
            if let index = self.index(of: otherElement) {
                remove(at: index)
            } else {
                insert(otherElement)
            }
        }
    }
}
