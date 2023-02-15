import Foundation

public struct GetWaterFountainsUseCase {
    private let repository = WaterFountainRepository()

    public init() {}

    public func execute(server: Server) async -> [WaterFountain] {
        try! await repository.all(server: server)
    }
}
