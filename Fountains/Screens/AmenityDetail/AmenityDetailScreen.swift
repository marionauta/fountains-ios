import DomainLayer
import HelperKit
import Perception
import SwiftUI

struct AmenityDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AmenityDetailViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            AmenityDetailView()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task {
            await viewModel.loadAmenityImage()
        }
    }

    private var title: LocalizedStringKey {
        viewModel.amenity.name.nilIfEmpty.map(LocalizedStringKey.init(stringLiteral:))
            ?? "fountain_detail_fallback_title"
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            CloseButton(dismiss: dismiss)
        }
    }
}

struct AmenityDetailView: View {
    @Environment(AmenityDetailViewModel.self) private var viewModel

    var body: some View {
        WithPerceptionTracking {
            LazyVStack(spacing: 0) {
                if let imageUrl = viewModel.fountainImageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 250)
                    .clipped()
                }

                AdView(adUnit: Secrets.admobDetailAdUnitId)

                FountainPropertyRow(
                    name: "fountain_detail_wheelchair_title",
                    description: "fountain_detail_wheelchair_description",
                    value: viewModel.amenity.properties.wheelchair.title
                )

                switch viewModel.amenity {
                case let fountain as Amenity.Fountain:
                    FountainPropertyRow(
                        name: "fountain_detail_bottle_title",
                        description: "fountain_detail_bottle_description",
                        value: fountain.properties.bottle.title
                    )
                case let restroom as Amenity.Restroom:
                    FountainPropertyRow(
                        name: "fountain_detail_changing_table_title",
                        description: "fountain_detail_changing_table_description",
                        value: restroom.properties.changingTable.title
                    )
                default:
                    EmptyView()
                }

                if let checkDate = viewModel.amenity.properties.checkDate {
                    FountainPropertyRow(
                        name: "fountain_detail_check_date_title",
                        description: "fountain_detail_check_date_description",
                        value: checkDate.formatted(date: .long, time: .omitted)
                    )
                }

                Link("fountain_detail_something_wrong_button", destination: viewModel.somethingWrongUrl)
                    .padding(16)
            }
        }
    }
}

private extension Amenity.BasicValue {
    var title: LocalizedStringKey {
        switch self {
        case .unknown: "property_value_unknown"
        case .no: "property_value_no"
        case .yes: "property_value_yes"
        default: "property_value_unknown"
        }
    }
}

private extension Amenity.WheelchairValue {
    var title: LocalizedStringKey {
        switch self {
        case .unknown: "property_value_unknown"
        case .no: "property_value_no"
        case .limited: "property_value_limited"
        case .yes: "property_value_yes"
        default: "property_value_unknown"
        }
    }
}
