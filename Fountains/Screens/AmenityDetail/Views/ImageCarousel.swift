import OpenLocationsShared
import SwiftUI

extension ImageMetadata: @retroactive Identifiable {}

struct ImageCarousel: View {
    let images: [ImageMetadata]

    var body: some View {
        if !images.isEmpty {
            TabView {
                ForEach(images) { image in
                    ImageCarouselSlide(image: image)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .frame(height: 32.units)
        }
    }
}

private struct ImageCarouselSlide: View {
    let image: ImageMetadata

    var body: some View {
        AsyncImage(url: image.imageUrl) { image in
            Color.clear.overlay {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        } placeholder: {
            ProgressView()
        }
        .frame(height: 32.units)
        .clipShape(RoundedRectangle(cornerRadius: 1.units))
        .overlay(alignment: .bottomTrailing) {
            CreatorName(image: image)
        }
        .padding(.horizontal, 1.units)
    }
}

private struct CreatorName: View {
    @Environment(\.openURL) private var openURL: OpenURLAction
    @State private var showLicense: Bool = false
    let image: ImageMetadata

    var body: some View {
        if let username = image.creator?.username {
            Button {
                showLicense = true
            } label: {
                Text(username)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(.marker.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(4)
                    .contentShape(Rectangle())
            }
            .alert("creator_name_license_title", isPresented: $showLicense) {
                Button("general.close") {
                    showLicense = false
                }
                if let url = image.license?.url {
                    Button("creator_name_learn_more") {
                        openURL(url)
                    }
                }
            } message: {
                Text([image.creator?.username, image.license?.name].compactMap(\.self).joined(separator: ", "))
            }
        }
    }
}
