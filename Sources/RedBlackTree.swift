// Adapted from "A persistent tree using indirect enums in Swift" at
// https://airspeedvelocity.net/2015/07/22/a-persistent-tree-using-indirect-enums-in-swift/
//
// Also, certain ideas were taken from Matt Might's essays on purely functional red-black trees,
// which built upon Chris Okasaki's purely functional red-black trees.
// http://matt.might.net/articles/red-black-delete/

import Foundation

public enum NodeColor {
    case red
    case black
}

public indirect enum RedBlackTree<Element: Comparable> {
    case empty
    case node(color: NodeColor, left: RedBlackTree<Element>, element: Element, right: RedBlackTree<Element>)

    public init() {
        self = .empty
    }

    public init(element: Element, color: NodeColor = .black,
                left: RedBlackTree<Element> = .empty, right: RedBlackTree<Element> = .empty) {
        self = .node(color: color, left: left, element: element, right: right)
    }
}

extension RedBlackTree {
    public var isEmpty: Bool {
        if case .empty = self {
            return true
        } else {
            return false
        }
    }

    public var count: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, left, _, right):
            return 1 + left.count + right.count
        }
    }

    public var elements: Array<Element> {
        switch self {
        case .empty:
            return []
        case let .node(color: _, left: left, element: element, right: right):
            return left.elements + [element] + right.elements
        }
    }

    public func insert(_ newElement: Element) -> RedBlackTree<Element> {
        switch _insert(newElement, into: self) {
        case .empty:
            fatalError()
        case let .node(_, left, element, right):
            return .node(color: .black, left: left, element: element, right: right)
        }
    }

    public func contains(_ target: Element) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(color: _, left: left, element: element, right: right):
            if target < element { return left.contains(target) }
            else if target > element { return right.contains(target) }
            else { return true }
        }
    }
}

extension RedBlackTree {
    fileprivate func _insert(_ newElement: Element, into tree: RedBlackTree) -> RedBlackTree {
        switch tree {
        case .empty:
            return RedBlackTree(element: newElement, color: .red)
        case let .node(color: color, left: left, element: element, right: right):
            if newElement < element {
                return _balance(
                    RedBlackTree(
                        element: element,
                        color: color,
                        left: _insert(newElement, into: left),
                        right: right
                    )
                )
            } else if newElement > element {
                return _balance(
                    RedBlackTree(
                        element: element,
                        color: color,
                        left: left,
                        right: _insert(newElement, into: right)
                    )
                )
            } else {
                return tree
            }
        }
    }

//       Bz             Bz           Bx            Bx                  Ry
//      /  \           / \          /  \          /  \               /    \
//     Ry   d         Rx  d        a    Rz       a    Ry            Bx     Bz
//     / \            / \              / \          /  \      ==>  / \    /  \
//    Rx  c          a   Ry           Ry  d        b    Rz        a   b  c    d
//    / \               / \          / \                / \
//   a   b             b   c        b   c              c   d
    fileprivate func _balance(_ tree: RedBlackTree<Element>) -> RedBlackTree<Element> {
        switch tree {
        case let .node(.black, .node(.red, .node(.red, a, x, b), y, c), z, d):
            return .node(
                color: .red,
                left: .node(color: .black, left: a, element: x, right: b),
                element: y,
                right: .node(color: .black, left: c, element: z, right: d)
            )

        case let .node(.black, .node(.red, a, x, .node(.red, b, y, c)), z, d):
            return .node(
                color: .red,
                left: .node(color: .black, left: a, element: x, right: b),
                element: y,
                right: .node(color: .black, left: c, element: z, right: d)
            )

        case let .node(.black, a, x, .node(.red, .node(.red, b, y, c), z, d)):
            return .node(
                color: .red,
                left: .node(color: .black, left: a, element: x, right: b),
                element: y,
                right: .node(color: .black, left: c, element: z, right: d)
            )

        case let .node(.black, a, x, .node(.red, b, y, .node(.red, c, z, d))):
            return .node(
                color: .red,
                left: .node(color: .black, left: a, element: x, right: b),
                element: y,
                right: .node(color: .black, left: c, element: z, right: d)
            )

        default:
            return tree
        }
    }
}

extension RedBlackTree: ExpressibleByArrayLiteral {
    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        self = sequence.reduce(RedBlackTree()) { $0.insert($1) }
    }

    public init(arrayLiteral elements: Element...) {
        self = RedBlackTree(elements)
    }
}

extension RedBlackTree: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        var stack: Array<RedBlackTree> = []
        var current: RedBlackTree = self
        return AnyIterator {
            while true {
                switch current {
                case let .node(_, left, _, _):
                    stack.append(current)
                    current = left
                case .empty where !stack.isEmpty:
                    switch stack.removeLast() {
                    case let .node(_, _, element, right):
                        current = right
                        return element
                    default:
                        break
                    }
                case .empty:
                    return nil
                }
            }
        }
    }
}
