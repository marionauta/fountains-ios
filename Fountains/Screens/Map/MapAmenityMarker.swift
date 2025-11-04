import DomainLayer
import MapCluster
import MapKit
import OpenLocationsShared
import SwiftUI

struct MapAmenityMarker: View {
    let amenity: Amenity
    let onTap: () -> Void

    fileprivate static let closedColor: Color = Color.gray

    var body: some View {
        Group {
            switch amenity {
            case is Amenity.Fountain:
                Image(.marker)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundStyle(backgroundColor)
                    .padding(0.5)
                    .background(Color.white)
                    .clipShape(Circle())
            case is Amenity.Restroom:
                Text(verbatim: "WC")
                    .minimumScaleFactor(0.5)
                    .foregroundStyle(Color.white)
                    .padding(2)
                    .frame(width: 25, height: 25, alignment: .center)
                    .background(backgroundColor)
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
        .overlay(alignment: .topTrailing) {
            if amenity.properties.fee is Amenity.FeeValue.Yes {
                Text(verbatim: "$")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.white)
                    .frame(width: 10, height: 10, alignment: .center)
                    .padding(1)
                    .background(.accent)
                    .clipShape(Circle())
                    .padding(1)
                    .background(Color.white)
                    .clipShape(Circle())
                    .offset(x: 4, y: -4)
            }
        }
    }

    private var backgroundColor: Color {
        if amenity.properties.closed { return MapAmenityMarker.closedColor }
        return switch amenity {
        case is Amenity.Fountain: Color(.marker)
        case is Amenity.Restroom: Color(.markerRestroom)
        default: fatalError("Unknown amenity type: \(String(describing: type(of: amenity)))")
        }
    }
}

struct MapClusterMarker: View {
    let group: String?
    let count: Int
    var allClosed: Bool
    let onTap: () -> Void

    var body: some View {
        DefaultClusterView(count: count)
            .tint(backgroundColor)
            .onTapGesture(perform: onTap)
    }

    private var backgroundColor: Color {
        if allClosed { return MapAmenityMarker.closedColor }
        return switch group {
        case "restroom": Color(.markerRestroom)
        default: Color(.marker)
        }
    }
}
