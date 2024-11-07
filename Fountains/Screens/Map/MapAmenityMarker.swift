import DomainLayer
import MapCluster
import MapKit
import SwiftUI

struct MapAmenityMarker: View {
    let amenity: Amenity
    let onTap: () -> Void

    var body: some View {
        image
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 2, y: 2)
            .onTapGesture(perform: onTap)
    }

    private var image: Image {
        switch amenity {
        case is Fountain: Image(.marker)
        case is Amenity.Restroom: Image(.markerRestroom)
        default:
            {
                print("unknown amenity \(amenity.self)")
                return Image(systemName: "questionmark")
            }()
        }
    }
}

struct MapClusterMarker: View {
    let count: Int
    let onTap: () -> Void

    var body: some View {
        DefaultClusterView(count: count)
            .tint(Color(.marker))
            .onTapGesture(perform: onTap)
    }
}
