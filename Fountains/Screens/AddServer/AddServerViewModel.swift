import DomainLayer
import Foundation
import MapKit
import WaterFountains

final class AddServerViewModel: ObservableObject {
    private let getDiscoveredUseCase = GetDiscoveredServersUseCase()
    private let getInfoUseCase = GetServerInfoUseCase()
    private let addServerUseCase = CreateServerUseCase()

    @Published var isLoading: Bool = false
    @Published var discoveredServers: [ServerDiscoveryItemDto] = []
    @Published var address: String = ""
    @Published var serverInfo: ServerInfoDto?
    var previewMapRegion: MKCoordinateRegion {
        guard let serverInfo else { return MKCoordinateRegion() }
        return MKCoordinateRegion(
            center: serverInfo.area.location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.03,
                longitudeDelta: 0.03
            )
        )
    }

    @MainActor
    public func getDiscoveredServers() async {
        isLoading = true
        discoveredServers = await getDiscoveredUseCase.execute()
        isLoading = false
    }

    @MainActor
    public func getServerInfo() async {
//        guard let url = URL(string: address) else { return }
        isLoading = true
        serverInfo = await getInfoUseCase.execute(url: address)
        isLoading = false
    }

    @MainActor
    public func checkPredefinedServer(at address: String) async {
        self.address = address
        await getServerInfo()
    }

    public func addServer(callback: () -> Void) {
//        guard let area = serverInfo?.area, let address = URL(string: address) else { return }
//        let server = Server(name: area.displayName, address: address, location: area.location)
//        addServerUseCase.execute(server: server)
        callback()
    }
}

struct GetDiscoveredServersUseCase {
    private let dataSource = DiscoveryDataSource()

    @MainActor
    func execute() async -> [ServerDiscoveryItemDto] {
        try! await dataSource.all()
    }
}

struct GetServerInfoUseCase {
    private let dataSource = ServerInfoDataSource()

    @MainActor
    func execute(url: String) async -> ServerInfoDto? {
        try? await dataSource.get(baseUrl: url)
    }
}

extension LocationDto {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
