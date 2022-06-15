import DomainLayer
import SwiftUI

struct FountainDetailScreen: View {
    public var fountain: WaterFountain

    var body: some View {
        NavigationView {
            Form {
                Section("fountaindetail_location_title") {
                    HStack {
                        Text("fountaindetail_location_lat")
                        Spacer()
                        Text(fountain.location.latitude, format: .number)
                    }
                    HStack {
                        Text("fountaindetail_location_lng")
                        Spacer()
                        Text(fountain.location.longitude, format: .number)
                    }
                }

                Section("fountaindetail_details_title") {
                    HStack {
                        Text("fountaindetail_details_bottles")
                        Spacer()
                        Image(systemName: fountain.properties.bottle.imageName)
                    }
                    HStack {
                        Text("fountaindetail_details_wheelchairs")
                        Spacer()
                        Image(systemName: fountain.properties.wheelchair.imageName)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var title: LocalizedStringKey {
        fountain.name.nilIfEmpty.map(LocalizedStringKey.init(stringLiteral:)) ?? "fountaindetail_screen_title"
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
