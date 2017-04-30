import Foundation

public final class Graph<T: Hashable> {
    fileprivate var canvas = Set<Vertex<T>>()

    public init() {}

    public func addVertex(_ value: T) -> Vertex<T> {
        let vertex = Vertex(value: value)
        let (_, member) = canvas.insert(vertex)
        return member
    }

    public func addEdge(from source: Vertex<T>, to neighbour: Vertex<T>) {
        let edge = Edge(neighbour: neighbour)
        source.neighbours.append(edge)
    }
}

extension Graph: CustomStringConvertible {
    public var description: String {
        return canvas.description
    }
}

public extension Graph {
    var DOTDescription: String {
        var description = "digraph {\n"

        // SetIndex isn't convertible to an Int
        // So track indices manually here
        var indexes: [Vertex<T>: Int] = [:]

        canvas.enumerated().forEach { index, vertex in
            indexes[vertex] = index
            description += "    \(index) [label=\"\(vertex.value)\"]\n"
        }

        description += "\n"

        canvas.enumerated().forEach { index, vertex in
            vertex.neighbours.forEach { neighbour in
                guard let neighbourIndex = indexes[neighbour.neighbour] else { return }
                description += "    \(index) -> \(neighbourIndex)\n"
            }
        }

        description += "}"
        return description
    }
}

public final class Vertex<T: Hashable> {
    let value: T
    var neighbours = [Edge<T>]()

    init(value: T) {
        self.value = value
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "Vertex: \(value)\n" +
               "  Edges: \(neighbours)\n\n"
    }
}

extension Vertex: Equatable {
    public static func ==<T>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension Vertex: Hashable {
    public var hashValue: Int {
        return value.hashValue
    }
}

public final class Edge<T: Hashable> {
    let neighbour: Vertex<T>

    init(neighbour: Vertex<T>) {
        self.neighbour = neighbour
    }
}

extension Edge: CustomStringConvertible {
    public var description: String {
        return "Edge to: \(neighbour.value)"
    }
}


