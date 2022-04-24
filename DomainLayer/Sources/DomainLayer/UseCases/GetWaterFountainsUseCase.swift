import Foundation

public struct GetWaterFountainsUseCase {
    private let repository = WaterFountainRepository()

    public init() {}

    public func execute() async -> [WaterFountain] {
        return await repository.all()
    }
}
