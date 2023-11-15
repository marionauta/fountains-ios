import CoreLocation
import DomainLayer
import Foundation
import MapKit

protocol WithCoordinate {
    var coordinate: CLLocationCoordinate2D { get }
}

typealias MapSingle = WithCoordinate & Equatable & Identifiable

extension WithCoordinate {
    func distance(to other: any WithCoordinate) -> Double {
        MKMapPoint(coordinate).distance(to: MKMapPoint(other.coordinate))
    }
}

struct MapCluster<Single: MapSingle>: Equatable, Identifiable, WithCoordinate {
    let id: Single.ID
    var singles: [Single]

    var coordinate: CLLocationCoordinate2D {
        return centerpoint(of: singles.map(\.coordinate)) ?? .init()
    }
}

enum MapMarker<Single: MapSingle>: Equatable, Identifiable, WithCoordinate {
    case single(Single)
    case cluster(MapCluster<Single>)

    var id: Single.ID {
        switch self {
        case let .single(single):
            return single.id
        case let .cluster(cluster):
            return cluster.id
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case let .single(single):
            return single.coordinate
        case let .cluster(cluster):
            return cluster.coordinate
        }
    }

    func joining(other: Single) -> MapMarker {
        switch self {
        case let .single(single):
            return .cluster(MapCluster(id: single.id, singles: [single, other]))
        case let .cluster(cluster):
            var cluster = cluster
            cluster.singles.append(other)
            return .cluster(cluster)
        }
    }
}

func clusterize<Single: MapSingle>(_ singles: [Single], proximity: Double, bounds: MKMapRect?) -> [MapMarker<Single>] {
    var markers: [MapMarker<Single>] = []
    singlesLoop: for newSingle in singles {
        if let bounds, !bounds.contains(MKMapPoint(newSingle.coordinate)) { continue }
        for index in 0..<markers.count {
            let marker = markers[index]
            if newSingle.distance(to: marker) < proximity {
                let cluster = marker.joining(other: newSingle)
                markers.remove(at: index)
                markers.insert(cluster, at: index)
                continue singlesLoop
            }
        }
        markers.append(.single(newSingle))
    }
    return markers
}

private func centerpoint(of locations: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
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
    return CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
}
