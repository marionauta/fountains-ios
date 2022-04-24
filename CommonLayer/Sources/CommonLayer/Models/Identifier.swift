import Foundation

public struct Identifier<Owner> {
    public let value: UUID

    public init(_ uuid: UUID) {
        value = uuid
    }

    public init(_ string: String) {
        guard let uuid = UUID(uuidString: string) else {
            fatalError("Couldn't decode \(string) into UUID for \(type(of: Owner.self))")
        }
        value = uuid
    }
}

extension Identifier: Hashable {}
