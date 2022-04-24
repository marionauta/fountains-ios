import DomainLayer
import SwiftUI

struct FountainDetailScreen: View {
    public var fountain: WaterFountain

    var body: some View {
        NavigationView {
            Form {
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
            .navigationTitle(fountain.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
