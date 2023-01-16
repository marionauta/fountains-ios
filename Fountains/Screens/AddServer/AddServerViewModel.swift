import DomainLayer
import Foundation
import MapKit

final class AddServerViewModel: ObservableObject {
    private let getDiscoveredUseCase = GetDiscoveredServersUseCase()
    private let getInfoUseCase = GetServerInfoUseCase()
    private let addServerUseCase = CreateServerUseCase()

    @Published var isLoading: Bool = false
    @Published var discoveredServers: [ServerDiscoveryItem] = []
    @Published var address: String = ""
    @Published var serverInfo: ServerInfo?
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
        await discoveredServers = getDiscoveredUseCase.execute()
        isLoading = false
    }

    @MainActor
    public func getServerInfo() async {
        guard let url = URL(string: address) else { return }
        isLoading = true
        serverInfo = await getInfoUseCase.execute(url: url)
        isLoading = false
    }

    @MainActor
    public func checkPredefinedServer(at address: URL) async {
        self.address = address.absoluteString
        await getServerInfo()
    }

    public func addServer(callback: () -> Void) {
        guard let area = serverInfo?.area, let address = URL(string: address) else { return }
        let server = Server(name: area.displayName, address: address, location: area.location)
        addServerUseCase.execute(server: server)
        callback()
    }
}
