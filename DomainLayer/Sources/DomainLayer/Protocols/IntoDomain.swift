import Foundation

protocol IntoDomain {
    associatedtype DomainType

    func intoDomain() -> DomainType
}
