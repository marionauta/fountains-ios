import Combine
import DomainLayer
import Foundation

final class AreaListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let getAreasUseCase = GetAreasUseCase()
    private let deleteAreaUseCase = DeleteAreaUseCase()

    @Published var areas: [Area] = []
    @Published var route: AreaListCoordinator.Route?

    public func load() {
        cancellables = .init()
        getAreas()
    }

    func addArea() {
        route = .addArea
    }

    func openAppInfo() {
        route = .info
    }

    func closeModals() {
        route = nil
    }

    func deleteArea(areaId: Area.ID) {
        deleteAreaUseCase.execute(areaId: areaId)
    }

    private func getAreas() {
        getAreasUseCase.execute()
            .receive(on: DispatchQueue.main)
            .assign(to: \.areas, on: self)
            .store(in: &cancellables)
    }
}
