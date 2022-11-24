import DomainLayer
import Foundation
import MapKit

final class AddServerViewModel: ObservableObject {
    private let useCase = GetServerInfoUseCase()
    private let addServerUseCase = CreateServerUseCase()

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
    public func getServerInfo() async {
        guard let url = URL(string: address) else { return }
        serverInfo = await useCase.execute(url: url)

    }

    public func addServer(callback: () -> Void) {
        guard let area = serverInfo?.area, let address = URL(string: address) else { return }
        let server = Server(name: area.displayName, address: address, location: area.location)
        addServerUseCase.execute(server: server)
        callback()
    }
}
