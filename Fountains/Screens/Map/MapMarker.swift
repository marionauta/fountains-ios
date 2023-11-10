import CoreLocation
import DomainLayer
import Foundation
import MapKit

struct MapMarkerCluster: Equatable, Identifiable {
    let id: String
    let location: Location
    let count: Int
}

enum MapMarker: Equatable, Identifiable {
    case cluster(MapMarkerCluster)
    case fountain(Fountain)

    var id: String {
        switch self {
        case let .cluster(cluster):
            return cluster.id
        case let .fountain(fountain):
            return fountain.id.value
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .cluster(let cluster):
            return cluster.location.coordinate
        case .fountain(let fountain):
            return fountain.location.coordinate
        }
    }
}

private extension MapClusterMarker {
    struct Key: Hashable {
        let x: Double
        let y: Double
    }
}

func clusterize(mapRect: MKMapRect, fountains: [Fountain]) -> [MapMarker] {
    let hStart = mapRect.northWest.coordinate.longitude + 360
    let hEnd = mapRect.northEast.coordinate.longitude + 360
    let vStart = mapRect.northWest.coordinate.latitude
    let vEnd = mapRect.southWest.coordinate.latitude
    let horizontalSpan = hEnd - hStart
    let hStep = horizontalSpan / 9
    let verticalSpan = vEnd - vStart
    let vStep = verticalSpan / 9
    var dictionary: Dictionary<MapClusterMarker.Key, [Fountain]> = [:]
    for fountain in fountains {
        xLoop: for xx in 0..<9 {
            let x = Double(xx)
            for yy in 0..<9 {
                let y = Double(yy)
                let lon = fountain.location.longitude + 360
                if lon >= (hStart + (hStep * x)) && lon <= (hStart + (hStep * (x + 1))) {
                    let lat = fountain.location.latitude
                    if lat <= (vStart + (vStep * y)) && lat > (vStart + (vStep * (y + 1))) {
                        let key = MapClusterMarker.Key(x: x, y: y)
                        var list = dictionary[key] ?? []
                        list.append(fountain)
                        dictionary[key] = list
                        break xLoop
                    }
                }
            }
        }
    }
    return dictionary.values.compactMap { fountains -> MapMarker? in
        if fountains.count > 1 {
            let first = fountains.first!
            return .cluster(.init(id: first.id.value, location: fountains.first!.location, count: fountains.count))
        } else if let first = fountains.first {
            return .fountain(first)
        } else  {
            return nil
        }
    }
}
