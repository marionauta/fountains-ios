import DomainLayer
import HelperKit
import Perception
import SwiftUI

struct FountainDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(FountainDetailViewModel.self) private var viewModel

    var body: some View {
        ScrollView {
            FountainDetailView()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task {
            await viewModel.loadFountainImage()
        }
    }

    private var title: LocalizedStringKey {
        viewModel.fountain.name.nilIfEmpty.map(LocalizedStringKey.init(stringLiteral:))
            ?? "fountain_detail_fallback_title"
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            CloseButton(dismiss: dismiss)
        }
    }
}

struct FountainDetailView: View {
    @Environment(FountainDetailViewModel.self) private var viewModel

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
                    name: "fountain_detail_bottle_title",
                    description: "fountain_detail_bottle_description",
                    value: viewModel.fountain.properties.bottle.title
                )

                FountainPropertyRow(
                    name: "fountain_detail_wheelchair_title",
                    description: "fountain_detail_wheelchair_description",
                    value: viewModel.fountain.properties.wheelchair.title
                )

                if let checkDate = viewModel.fountain.properties.checkDate {
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
