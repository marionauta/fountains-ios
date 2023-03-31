import Foundation

public struct GetFountainsUseCase {
    private let repository = FountainRepository()

    public init() {}

    public func execute(area: Area) async -> [Fountain] {
        try! await repository.all(area: area)
    }
}
