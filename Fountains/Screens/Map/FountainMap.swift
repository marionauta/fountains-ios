import Combine
import MapKit
import SwiftUI
import DomainLayer

struct FountainMap: UIViewRepresentable {
    private let annotations: [FountainMapAnnotation]
    @Binding private var region: MKCoordinateRegion
    private var onAnnotationTap: ((FountainMapAnnotation) -> Void)?

    init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        annotationItems: [FountainMapAnnotation],
        onAnnotationTap: ((FountainMapAnnotation) -> Void)? = nil
    ) {
        self._region = coordinateRegion
        self.annotations = annotationItems
        self.onAnnotationTap = onAnnotationTap
    }

    func makeCoordinator() -> FountainMap.Coordinator {
        Coordinator(map: self)
    }

    func makeUIView(context: Context) -> some MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.register(
            MapAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
        view.register(
            MapAnnotationClusterView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
        configureView(view, context: context)
        return view
    }

    func updateUIView(_ view: UIViewType, context: Context) {
        configureView(view, context: context)
    }

    func configureView(_ view: MKMapView, context: Context) {
        view.mapType = .standard
        view.showsUserLocation = true
        view.userTrackingMode = .follow

        if region.center != view.region.center || region.span != view.region.span {
            view.setRegion(region, animated: false)
        }

        updateAnnotations(in: view)
    }

    private func updateAnnotations(in view: MKMapView) {
        let currentAnnotations = view.annotations.compactMap { $0 as? SimpleAnnotation }

        let annotationsToRemove = currentAnnotations.filter { annotation in
            !self.annotations.contains { $0.annotationId == annotation.annotationId }
        }
        let annotationsToAdd = annotations.filter { fountainAnn in
            !currentAnnotations.contains { $0.annotationId == fountainAnn.annotationId }
        }

        view.removeAnnotations(annotationsToRemove)
        view.addAnnotations(annotationsToAdd.map(SimpleAnnotation.init(annotation:)))
    }
}

extension FountainMap {
    final class Coordinator: NSObject, MKMapViewDelegate {
        private var cancellables = Set<AnyCancellable>()
        private let map: FountainMap
        @Published private var updateRegion: MKCoordinateRegion = .init()

        init(map: FountainMap) {
            self.map = map
            super.init()
            setupBindings()
        }

        private func setupBindings() {
            $updateRegion
                .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
                .assign(to: \.region, on: map)
                .store(in: &cancellables)
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            updateRegion = mapView.region
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            mapView.deselectAnnotation(view.annotation, animated: false)

            guard let simple = view.annotation as? SimpleAnnotation else { return }

            let annotation = simple.annotation
            map.onAnnotationTap?(annotation)
        }
    }
}

private final class SimpleAnnotation: NSObject, MKAnnotation {
    public let annotation: FountainMapAnnotation
    public var annotationId: AnyHashable { annotation.annotationId }

    init(annotation: FountainMapAnnotation) {
        self.annotation = annotation
    }

    var coordinate: CLLocationCoordinate2D { annotation.coordinate }
}

private final class MapAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let mapAnnotation = (newValue as? SimpleAnnotation)?.annotation {
                self.clusteringIdentifier = mapAnnotation.clusteringIdentifier
                self.markerTintColor = mapAnnotation.tintColor
                self.glyphTintColor = mapAnnotation.foregroundTintColor
                self.glyphImage = mapAnnotation.glyphImage
            }
        }
    }
}

private final class MapAnnotationClusterView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let clusterAnnotation = newValue as? MKClusterAnnotation {
                let mapAnnotations = clusterAnnotation
                    .memberAnnotations
                    .compactMap { $0 as? SimpleAnnotation }
                    .map(\.annotation)

                guard let mapAnnotation = mapAnnotations.first else {
                    return
                }

                self.subtitleVisibility = .hidden
                self.collisionMode = .circle
                self.markerTintColor = mapAnnotation.tintColor
                self.glyphTintColor = mapAnnotation.foregroundTintColor
                self.glyphImage = drawGlyph(
                    sized: CGSize(width: 32, height: 32),
                    foreground: mapAnnotation.foregroundTintColor,
                    withCount: mapAnnotations.count
                )
            }
        }
    }

    private func drawGlyph(
        sized size: CGSize,
        foreground: UIColor?,
        withCount count: Int
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let textAttributes: [NSAttributedString.Key: NSObject] = [
                NSAttributedString.Key.foregroundColor: foreground ?? .white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
            ]
            let text = "\(count)" as NSString
            let textSize = text.size(withAttributes: textAttributes)
            let textRect = CGRect(x: size.width / 2 - textSize.width / 2,
                                  y: size.height / 2 - textSize.height / 2,
                                  width: textSize.width,
                                  height: textSize.height)
            text.draw(in: textRect, withAttributes: textAttributes)
        }
    }
}
