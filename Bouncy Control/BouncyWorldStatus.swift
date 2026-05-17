import Foundation

struct BouncyWorldStatus: Decodable {
    let width: Double
    let height: Double
    let frozen: Bool
    let wrapping: Bool
    let bodyCounts: [BouncyBodyCount]
    let bodies: [BouncyBody]
    let clients: [JSONValue]

    var totalBodies: Int {
        bodyCounts.reduce(0) { $0 + $1.count }
    }
}

struct BouncyBodyCount: Decodable, Identifiable {
    let size: Int
    let count: Int

    var id: Int { size }
}

struct BouncyBody: Decodable, Identifiable {
    let id: Int
    let radius: Double
    let mass: Double
    let position: BouncyVector
    let velocity: BouncyVector
}

struct BouncyVector: Decodable {
    let x: Double
    let y: Double
}

enum JSONValue: Decodable, CustomStringConvertible {
    case string(String)
    case number(Double)
    case integer(Int)
    case boolean(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(Int.self) {
            self = .integer(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported JSON value")
        }
    }

    var description: String {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return value.formatted(.number.precision(.fractionLength(0...2)))
        case .integer(let value):
            return String(value)
        case .boolean(let value):
            return value ? "true" : "false"
        case .object(let value):
            return value
                .keys
                .sorted()
                .map { "\($0): \(value[$0]!.description)" }
                .joined(separator: ", ")
        case .array(let value):
            return value.map(\.description).joined(separator: ", ")
        case .null:
            return "null"
        }
    }
}
