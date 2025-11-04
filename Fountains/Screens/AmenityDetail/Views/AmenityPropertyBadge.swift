import DomainLayer
import OpenLocationsShared
import SwiftUI

struct AmenityPropertyBadge: View {
    enum Variant {
        case positive, negative, limited, unknown
    }

    let variant: Variant

    init(variant: Variant) {
        self.variant = variant
    }

    init(variant: any IntoVariant) {
        self.variant = variant.intoVariant()
    }

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20, alignment: .center)
            .foregroundStyle(foreground)
            .padding(2)
            .background(.white)
            .clipShape(Circle())
    }

    private var image: Image {
        switch variant {
        case .positive:
            Image(systemName: "checkmark.circle.fill")
        case .negative:
            Image(systemName: "xmark.circle.fill")
        case .limited:
            Image(systemName: "exclamationmark.circle.fill")
        case .unknown:
            Image(systemName: "questionmark.circle.fill")
        }
    }

    private var foreground: some ShapeStyle {
        switch variant {
        case .positive:
            Color.green
        case .negative:
            Color.red
        case .limited:
            Color.orange
        case .unknown:
            Color.gray
        }
    }
}

protocol IntoVariant {
    func intoVariant() -> AmenityPropertyBadge.Variant
}

extension AmenityPropertyBadge.Variant: IntoVariant {
    func intoVariant() -> AmenityPropertyBadge.Variant {
        self
    }
}

extension Amenity.BasicValue: IntoVariant {
    func intoVariant() -> AmenityPropertyBadge.Variant {
        switch self {
        case .no: .negative
        case .yes: .positive
        case .unknown: .unknown
        default: .unknown
        }
    }
}

extension Amenity.WheelchairValue: IntoVariant {
    func intoVariant() -> AmenityPropertyBadge.Variant {
        switch self {
        case .no: .negative
        case .limited: .limited
        case .yes: .positive
        case .unknown: .unknown
        default: .unknown
        }
    }
}

extension Amenity.AccessValue: IntoVariant {
    func intoVariant() -> AmenityPropertyBadge.Variant {
        switch self {
        case .no, .private_: .negative
        case .customers, .permissive: .limited
        case .yes: .positive
        case .unknown: .unknown
        default: .unknown
        }
    }
}
