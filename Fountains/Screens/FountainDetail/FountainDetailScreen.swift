import DomainLayer
import HelperKit
import SwiftUI

struct FountainDetailScreen: View {
    @Environment(\.dismiss) private var dismiss

    public var fountain: Fountain
    @ObservedObject public var viewModel: FountainDetailViewModel

    var body: some View {
        VStack(spacing: 0) {
            if let imageUrl = viewModel.fountainImageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
                .clipped()
            }

            FountainPropertyRow(
                name: "fountain_detail_bottle_title",
                description: "fountain_detail_bottle_description",
                value: fountain.properties.bottle.title
            )

            FountainPropertyRow(
                name: "fountain_detail_wheelchair_title",
                description: "fountain_detail_wheelchair_description",
                value: fountain.properties.wheelchair.title
            )

            if let checkDate = fountain.properties.checkDate {
                FountainPropertyRow(
                    name: "fountain_detail_check_date_title",
                    description: "fountain_detail_check_date_description",
                    value: checkDate.formatted(date: .long, time: .omitted)
                )
            }

            Link("fountain_detail_something_wrong_button", destination: somethingWrongUrl)
                .padding(16)

            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton(dismiss: dismiss)
            }
        }
        .task {
            await viewModel.loadFountainImage(for: fountain.properties.mapillaryId)
        }
    }

    var title: LocalizedStringKey {
        fountain.name.nilIfEmpty.map(LocalizedStringKey.init(stringLiteral:)) ?? "fountain_detail_fallback_title"
    }

    var somethingWrongUrl: URL {
        let baseUrl = KnownUris.help(slug: "corregir").absoluteString
        return URL(string: "\(baseUrl)&lat=\(fountain.location.latitude)&lng=\(fountain.location.longitude)")!
    }
}

private extension Fountain.Properties.Value {
    var title: LocalizedStringKey {
        switch self {
        case .unknown:
            return "property_value_unknown"
        case .no:
            return "property_value_no"
        case .limited:
            return "property_value_limited"
        case .yes:
            return "property_value_yes"
        }
    }
}
