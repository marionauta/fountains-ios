import DomainLayer
import MapCluster
import MapKit
import SwiftUI

struct MapAmenityMarker: View {
    let amenity: Amenity
    let onTap: () -> Void

    var body: some View {
        Group {
            switch amenity {
            case is Amenity.Fountain:
                Image(.marker)
                    .background(Color.white)
                    .clipShape(Circle())
            case is Amenity.Restroom:
                Text(verbatim: "WC")
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
                    .padding(2)
                    .frame(width: 25, height: 25, alignment: .center)
                    .background(Color(.markerRestroom))
                    .clipShape(Circle())
                    .padding(1.5)
                    .background(Color.white)
                    .clipShape(Circle())
            default:
                EmptyView()
            }
        }
        .shadow(radius: 2, y: 2)
        .onTapGesture(perform: onTap)
    }
}

struct MapClusterMarker: View {
    let group: String?
    let count: Int
    let onTap: () -> Void

    var body: some View {
        DefaultClusterView(count: count)
            .tint(color)
            .onTapGesture(perform: onTap)
    }

    private var color: Color {
        switch group {
        case "restroom": Color(.markerRestroom)
        default: Color(.marker)
        }
    }
}
