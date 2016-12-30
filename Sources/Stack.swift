public struct Stack<A> {
    fileprivate var _array = Array<A>()

    public init() { }

    public var count: Int { return _array.count }

    public mutating func push(_ element: A) {
        _array.append(element)
    }

    public func peek() -> A? {
        return _array.last
    }

    public mutating func pop() -> A? {
        return _array.popLast()
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
