import DomainLayer
import OpenLocationsShared
import Perception
import SwiftUI

struct AmenityDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL: OpenURLAction
    @Environment(AmenityDetailViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            AmenityDetailView()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task {
            await viewModel.load()
        }
    }

    private var title: LocalizedStringKey {
        if let name = viewModel.amenity.name.nilIfEmpty {
            return LocalizedStringKey(name)
        }
        return switch viewModel.amenity {
        case is Amenity.Fountain: "amenity_detail_fountain_title"
        case is Amenity.Restroom: "amenity_detail_restroom_title"
        default: fatalError("Unknown amenity \(String(describing: viewModel.amenity))")
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            CloseButton(dismiss: dismiss)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Menu("amenity_detail_open_in_maps", systemImage: "map") {
                if let apple = viewModel.appleMapsUrl {
                    Button("amenity_detail_open_in_apple_maps") {
                        openURL(apple)
                    }
                }
                if let google = viewModel.googleMapsUrl {
                    Button("amenity_detail_open_in_google_maps") {
                        openURL(google)
                    }
                }
            }
        }
    }
}

struct AmenityDetailView: View {
    @Environment(\.openURL) private var openURL: OpenURLAction
    @Environment(AmenityDetailViewModel.self) private var viewModel

    var body: some View {
        WithPerceptionTracking {
            LazyVStack(spacing: 0) {
                ImageCarousel(images: viewModel.images)

                AdView(adUnit: Secrets.admobDetailAdUnitId)
                    .padding(.top, 8)

                if viewModel.amenity.properties.closed {
                    Text("amenity_detail_not_working_notice")
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 8)
                        .padding(.horizontal, 8)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    let hideFee = viewModel.amenity.properties.fee is Amenity.FeeValue.No
                        && viewModel.amenity.properties.access == .customers
                    if !hideFee {
                        AmenityPropertyCell {
                            viewModel.amenity.properties.fee.title
                        } subtitle: {
                            if let subtitle = (viewModel.amenity.properties.fee as? Amenity.FeeValue.Yes)?.amount {
                                Text(subtitle)
                            }
                        } image: {
                            Image(systemName: "dollarsign.circle")
                        } badge: {
                            switch viewModel.amenity.properties.fee {
                            case is Amenity.FeeValue.Yes, is Amenity.FeeValue.Donation:
                                AmenityPropertyBadge(variant: .limited)
                            case is Amenity.FeeValue.Unknown:
                                AmenityPropertyBadge(variant: .unknown)
                            default:
                                nil
                            }
                        }
                    }

                    if viewModel.amenity.properties.access != .yes {
                        AmenityPropertyCell {
                            "amenity_detail_access_title"
                        } subtitle: {
                            let subtitle: LocalizedStringKey = switch viewModel.amenity.properties.access {
                            case .customers: "access_value_customers_title"
                            case .permissive: "access_value_permissive_title"
                            default: "property_value_unknown"
                            }
                            Text(subtitle)
                        } image: {
                            Image(systemName: "figure.walk")
                        } badge: {
                            AmenityPropertyBadge(variant: viewModel.amenity.properties.access)
                        }
                    }

                    switch viewModel.amenity {
                    case let fountain as Amenity.Fountain:
                        AmenityPropertyCell {
                            "amenity_detail_bottle_title"
                        } image: {
                            Image(systemName: "waterbottle")
                        } badge: {
                            AmenityPropertyBadge(variant: fountain.properties.bottle)
                        }

                    case let restroom as Amenity.Restroom:
                        AmenityPropertyCell {
                            "amenity_detail_handwashing_title"
                        } image: {
                            Image(systemName: "sink")
                        } badge: {
                            AmenityPropertyBadge(variant: restroom.properties.handwashing)
                        }

                        AmenityPropertyCell {
                            "amenity_detail_changing_table_title"
                        } image: {
                            Image(systemName: "figure.and.child.holdinghands")
                        } badge: {
                            AmenityPropertyBadge(variant: restroom.properties.changingTable)
                        }
                    default:
                        EmptyView()
                    }

                    AmenityPropertyCell {
                        "amenity_detail_wheelchair_title"
                    } image: {
                        Image(systemName: "figure.roll")
                    } badge: {
                        AmenityPropertyBadge(variant: viewModel.amenity.properties.wheelchair)
                    }

                    if let checkDate = viewModel.amenity.properties.checkDate {
                        AmenityPropertyCell {
                            "amenity_detail_check_date_title"
                        } subtitle: {
                            Text(checkDate.formatted(date: .abbreviated, time: .omitted))
                        } image: {
                            Image(systemName: "calendar")
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 8)

                Text("amenity_detail_feedback_title")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)

                HStack(alignment: .center, spacing: 8) {
                    FeedbackButton(variant: .good, isSelected: false) {
                        viewModel.sendReport(state: .good)
                    }
                    FeedbackButton(variant: .bad, isSelected: false) {
                        viewModel.sendReport(state: .bad)
                    }
                }
                .padding(8)

                ForEach(viewModel.comments, id: \.id) { comment in
                    FeedbackCommentRow(comment: comment)
                        .padding(.horizontal, 8)
                        .padding(.top, 6)
                }

                Button("amenity_detail_how_to_fix_button") {
                    guard let url = viewModel.fixGuideUrl() else { return }
                    openURL(url)
                }
                .padding(.top, 16)
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
