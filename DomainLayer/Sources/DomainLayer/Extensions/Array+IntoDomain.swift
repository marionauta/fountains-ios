import Foundation

extension Array where Element: IntoDomain {
    func intoDomain() -> [Element.DomainType] {
        map { $0.intoDomain() }
    }
}
