import DomainLayer
import Foundation

final class AddAreaViewModel: ObservableObject {
    private let searchAreasUseCase = SearchAreasUseCase()
    private let storeAreaUseCase = StoreAreaUseCase()

    @Published var isLoading: Bool = false
    @Published var discoveredAreas: [Area] = []
    @Published var query: String = ""
    @Published var selectedArea: Area?

    @MainActor
    public func searchForAreas() async {
        guard !query.isEmpty else { return }
        isLoading = true
        discoveredAreas = await searchAreasUseCase.execute(name: query)
        isLoading = false
    }

    public func storeArea(callback: () -> Void) {
        guard let area = selectedArea else { return callback() }
        storeAreaUseCase.execute(area: area)
        callback()
    }
}
