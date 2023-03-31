import DomainLayer
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

            HStack {
                Text("fountaindetail_details_bottles")
                Spacer()
                Image(systemName: fountain.properties.bottle.imageName)
            }

            HStack {
                Text("fountaindetail_details_wheelchairs")
                Spacer()
                Image(systemName: fountain.properties.wheelchair.imageName)
            }

            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Label("general.close", systemImage: "xmark")
                }
            }
        }
        .task {
            await viewModel.loadFountainImage(for: fountain.properties.mapillaryId)
        }
    }

    var title: LocalizedStringKey {
        fountain.name.nilIfEmpty.map(LocalizedStringKey.init(stringLiteral:)) ?? "fountaindetail_screen_title"
    }
}

private extension Fountain.Properties.Value {
    var imageName: String {
        switch self {
        case .undefined:
            return "questionmark.app.dashed"
        case .no:
            return "nosign"
        case .limited:
            return "pyramid"
        case .yes:
            return "checkmark.seal"
        }
    }
}
