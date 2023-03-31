import Foundation

public struct Identifier<Owner> {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

extension Identifier: Hashable {}
