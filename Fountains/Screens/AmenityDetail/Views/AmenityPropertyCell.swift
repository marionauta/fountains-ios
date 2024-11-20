import SwiftUI

struct AmenityPropertyCell: View {
    let title: LocalizedStringKey
    let subtitle: Text?
    let image: Image
    let badge: AmenityPropertyBadge?

    init(
        title: () -> LocalizedStringKey,
        @ViewBuilder subtitle: () -> Text? = { nil },
        image: () -> Image,
        badge: () -> AmenityPropertyBadge? = { nil }
    ) {
        self.title = title()
        self.subtitle = subtitle()
        self.image = image()
        self.badge = badge()
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.secondary)
                .frame(width: 50, height: 50)
                .overlay(alignment: .bottomLeading) {
                    badge
                }

            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            if let subtitle {
                subtitle
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
