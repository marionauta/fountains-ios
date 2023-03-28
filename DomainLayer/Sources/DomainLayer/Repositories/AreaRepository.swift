import Combine
import Foundation
import WaterFountains

struct AreaRepository {
    private let searchDataSource = NominatimDataSource()
    private let storedDataSource = StoredAreasDataSource()

    func add(area: Area) {
        Task { @MainActor in
            try? await storedDataSource.add(area: area.intoData())
        }
    }

    func all() -> some Publisher<[Area], Error> {
        let subject = CurrentValueSubject<[StoredArea], Error>([])
        storedDataSource.allStream().collect(subject: subject)
        return subject.map { areas in areas.intoDomain() }
    }

    func delete(areaId: Area.ID) {
        Task { @MainActor in
            try? await storedDataSource.delete(id: areaId)
        }
    }

    func search(name: String) async -> [AreaOsm] {
        return await Task { @MainActor in
            (try? await searchDataSource.search(name: name)) ?? []
        }.value
    }
}
