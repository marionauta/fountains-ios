import CoreLocation
import DomainLayer
import Foundation
import MapKit

struct MapMarkerCluster: Equatable, Identifiable {
    let id: String
    var fountains: [Fountain]

    var coordinate: CLLocationCoordinate2D {
        return centerpoint(of: fountains.map(\.location))?.coordinate ?? .init()
    }
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
        case let .cluster(cluster):
            return cluster.coordinate
        case let .fountain(fountain):
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

func clusterize(fountains: [Fountain], proximity: Double) -> [MapMarker] {
    var markers: [MapMarker] = []
    fountainsLoop: for fountain in fountains {
        for index in 0..<markers.count {
            switch markers[index] {
            case let .fountain(old_fountain):
                if MKMapPoint(fountain.location.coordinate).distance(to: .init(old_fountain.location.coordinate)) < proximity {
                    let cluster = MapMarker.cluster(.init(id: old_fountain.id.value, fountains: [old_fountain, fountain]))
                    markers.remove(at: index)
                    markers.insert(cluster, at: index)
                    continue fountainsLoop
                }
            case let .cluster(cluster):
                if MKMapPoint(fountain.location.coordinate).distance(to: .init(cluster.coordinate)) < proximity {
                    var cluster = cluster
                    cluster.fountains.append(fountain)
                    markers.remove(at: index)
                    markers.insert(.cluster(cluster), at: index)
                    continue fountainsLoop
                }
            }
        }
        markers.append(.fountain(fountain))
    }
    return markers
}

private func centerpoint(of locations: [Location]) -> Location? {
    guard !locations.isEmpty else { return nil }
    var minLat = 90.0
    var maxLat = -90.0
    var minLon = 180.0
    var maxLon = -180.0
    for location in locations {
        if location.latitude  < minLat { minLat = location.latitude }
        if location.latitude  > maxLat { maxLat = location.latitude }
        if location.longitude < minLon { minLon = location.longitude }
        if location.longitude > maxLon { maxLon = location.longitude }
    }
    return Location(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
}
