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

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    AmenityPropertyCell(
                        title: viewModel.amenity.properties.fee.title,
                        image: Image(systemName: "dollarsign.circle"),
                        value: viewModel.amenity.properties.fee
                    )

                    switch viewModel.amenity {
                    case let fountain as Amenity.Fountain:
                        AmenityPropertyCell(
                            title: "fountain_detail_bottle_title",
                            image: Image(systemName: "waterbottle"),
                            value: fountain.properties.bottle
                        )
                    case let restroom as Amenity.Restroom:
                        AmenityPropertyCell(
                            title: "fountain_detail_handwashing_title",
                            image: Image(systemName: "sink"),
                            value: restroom.properties.handwashing
                        )
                        AmenityPropertyCell(
                            title: "fountain_detail_changing_table_title",
                            image: Image(systemName: "figure.and.child.holdinghands"),
                            value: restroom.properties.changingTable
                        )
                    default:
                        EmptyView()
                    }
                    AmenityPropertyCell(
                        title: "fountain_detail_wheelchair_title",
                        image: Image(systemName: "figure.roll"),
                        value: viewModel.amenity.properties.wheelchair
                    )
                }
                .padding(.top, 8)
                .padding(.horizontal, 8)

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

private extension Amenity.FeeValue {
    var title: LocalizedStringKey {
        switch self {
        case is Unknown: "fee_value_unknown_title"
        case is No: "fee_value_no_title"
        case is Donation: "fee_value_donation_title"
        case is Yes: "fee_value_yes_title"
        default: "fee_value_unknown_title"
        }
    }
}
