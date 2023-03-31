import Foundation

public struct GetFountainsUseCase {
    private let repository = FountainRepository()

    public init() {}

    public func execute(area: Area) async -> [Fountain] {
        await repository.all(area: area)
    }
}
