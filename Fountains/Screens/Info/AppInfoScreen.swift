import CommonLayer
import DomainLayer
import SwiftUI

struct AppInfoScreen: View {
    @State private var isEasterShown: Bool = false
    @AppStorage(AdView.Constants.adsHiddenKey) private var areAdsHidden: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
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
            .onTapGesture(count: 50) {
                isEasterShown = true
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("app_info_title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton(dismiss: dismiss)
            }
        }
        .alert(isPresented: $isEasterShown) {
            Alert(
                title: Text("app_info_easteregg_title"),
                message: Text("app_info_easteregg_content"),
                dismissButton: .default(Text("app_info_easteregg_ok")) {
                areAdsHidden.toggle()
                isEasterShown = false
            })
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
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .foregroundColor(.primary)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
