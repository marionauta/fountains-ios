import CoreLocation
import UIKit

protocol FountainMapAnnotation {
    var annotationId: AnyHashable { get }
    var coordinate: CLLocationCoordinate2D { get }
    var clusteringIdentifier: String? { get }
    var glyphImage: UIImage? { get }
    var tintColor: UIColor? { get }
    var foregroundTintColor: UIColor? { get }
}
