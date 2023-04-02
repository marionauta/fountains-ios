import CommonLayer
import DomainLayer
import SwiftUI

struct AppInfoScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Link(destination: KnownUris.website) {
                AppInfoRow(title: "app_info_website_title", description: "app_info_website_content")
            }

            Link(destination: KnownUris.developer) {
                AppInfoRow(title: "app_info_developer_title", description: "app_info_developer_content")
            }

            AppInfoRow(
                title: "app_info_app_version_title",
                description: Bundle.main.fullVersionString
            )

            Spacer()
        }
        .navigationTitle("app_info_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton(dismiss: dismiss)
            }
        }
    }
}

private struct AppInfoRow: View {
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    init(title: LocalizedStringKey, description: LocalizedStringKey) {
        self.title = title
        self.description = description
    }

    init(title: LocalizedStringKey, description: String) {
        self.title = title
        self.description = LocalizedStringKey(description)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(16)
                Spacer()
            }
            Divider()
        }
    }
}