import SwiftUI
import DomainLayer

private enum Value {
    case unknown, no, limited, yes

    init(value: Amenity.BasicValue) {
        switch value {
        case .no:
            self = .no
        case .yes:
            self = .yes
        default:
            self = .unknown
        }
    }

    init(value: Amenity.WheelchairValue) {
        switch value {
        case .no:
            self = .no
        case .limited:
            self = .limited
        case .yes:
            self = .yes
        default:
            self = .unknown
        }
    }

    init(value: Amenity.FeeValue) {
        switch value {
        case is Amenity.FeeValue.No:
            self = .no
        case is Amenity.FeeValue.Donation:
            self = .limited
        case is Amenity.FeeValue.Yes:
            self = .yes
        default:
            self = .unknown
        }
    }
}

struct AmenityPropertyCell: View {
    private let title: LocalizedStringKey
    private let subtitle: String?
    private let image: Image
    private let value: Value

    init(title: LocalizedStringKey, image: Image, value: Amenity.BasicValue) {
        self.title = title
        self.image = image
        self.value = .init(value: value)
        self.subtitle = nil
    }

    init(title: LocalizedStringKey, image: Image, value: Amenity.WheelchairValue) {
        self.title = title
        self.image = image
        self.value = .init(value: value)
        self.subtitle = nil
    }

    init(title: LocalizedStringKey, image: Image, value: Amenity.FeeValue) {
        self.title = title
        self.image = image
        self.value = .init(value: value)
        self.subtitle = if let yes = value as? Amenity.FeeValue.Yes {
            yes.amount
        } else {
            nil
        }
    }

    var body: some View {
        if value == .unknown {
            EmptyView()
        } else {
            VStack(alignment: .center, spacing: 8) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
                    .frame(width: 50, height: 50)
                    .overlay(alignment: .bottomLeading) {
                        switch value {
                        case .unknown:
                            EmptyView()
                        case .no:
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .foregroundStyle(.red)
                                .padding(2)
                                .background(.white)
                                .clipShape(Circle())
                        case .limited:
                            Image(systemName: "exclamationmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .foregroundStyle(.orange)
                                .padding(2)
                                .background(.white)
                                .clipShape(Circle())
                        case .yes:
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20, alignment: .bottomLeading)
                                .foregroundStyle(.green)
                                .padding(2)
                                .background(.white)
                                .clipShape(Circle())
                        }
                    }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                if let subtitle {
                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(8)
            .background(Color.primary.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
