import DomainLayer
import SwiftUI

struct FountainDetailScreen: View {
    public var fountain: WaterFountain

    var body: some View {
        NavigationView {
            Form {
                Section("Location") {
                    HStack {
                        Text("Latitude")
                        Spacer()
                        Text(fountain.location.latitude, format: .number)
                    }
                    HStack {
                        Text("Longitude")
                        Spacer()
                        Text(fountain.location.longitude, format: .number)
                    }
                }

                Section("Details") {
                    HStack {
                        Text("Bottles")
                        Spacer()
                        Image(systemName: fountain.properties.bottle.imageName)
                    }
                    HStack {
                        Text("Wheelchairs")
                        Spacer()
                        Image(systemName: fountain.properties.wheelchair.imageName)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var title: String {
        fountain.name.nilIfEmpty ?? "Fountain"
    }
}

private extension WaterFountain.Properties.Value {
    var imageName: String {
        switch self {
        case .undefined:
            return "questionmark.app.dashed"
        case .no:
            return "nosign"
        case .limited:
            return "pyramid"
        case .yes:
            return "checkmark.seal"
        }
    }
}
