public struct Stack<A> {
    fileprivate var _array = Array<A>()

    public init() { }

    public init(element: A) {
        self.init(array: [element])
    }

    public init(array: Array<A>) {
        _array = array
    }

    public var arrayValue: Array<A> { return _array }
    
    public var count: Int { return _array.count }

    public mutating func push(_ element: A) {
        _array.append(element)
    }

    public mutating func replace(at index: Int, with element: A) {
        guard index >= 0 && index < _array.count else { return }
        _array[index] = element
    }

    public func peekAtTop() -> A? {
        return peek(at: _array.count - 1)
    }

    public func peekAtBottom() -> A? {
        return peek(at: 0)
    }

    public func peek(at index: Int) -> A? {
        guard index >= 0 && index < _array.count else { return nil }
        return _array[index]
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
    public static func == (lhs: Stack<A>, rhs: Stack<A>) -> Bool {
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
