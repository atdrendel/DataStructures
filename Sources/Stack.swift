public struct Stack<A> {
    fileprivate var _array = Array<A>()

    public init() { }

    public init(_ element: A) {
        push(element)
    }

    public var count: Int { return _array.count }

    public mutating func push(_ element: A) {
        _array.append(element)
    }

    public func peek() -> A? {
        return _array.last
    }

    @discardableResult public mutating func pop() -> A? {
        return _array.popLast()
    }

    public func forEach(_ body: (A) throws -> Void) rethrows -> Void {
        try _array.reversed().forEach(body)
    }

    public func element(where test: ((A) -> Bool)) -> A? {
        for element in _array.reversed() {
            if test(element) { return element }
        }
        return nil
    }
}

extension Stack where A: Equatable {
    static func == (lhs: Stack<A>, rhs: Stack<A>) -> Bool {
        return lhs._array == rhs._array
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
        var string = "Stack {\n"
        let elementDescriptions = _array.reversed().map({ "\t\($0),\n" })
        for elementDescription in elementDescriptions {
            string += elementDescription
        }
        string += "}"
        return string
    }
}
