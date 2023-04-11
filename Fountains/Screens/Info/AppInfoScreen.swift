import CommonLayer
import DomainLayer
import SwiftUI

struct AppInfoScreen: View {
    @State private var isEasterShown: Bool = false
    @AppStorage(AdView.Constants.adsHiddenKey) private var areAdsHidden: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                NavigationLink {
                    RoadmapCoordinator()
                } label: {
                    ContentRow(title: "roadmap_title", description: "roadmap_subtitle")
                }
            }

            Link(destination: KnownUris.website) {
                ContentRow(title: "app_info_website_title", description: "app_info_website_content")
            }

            Link(destination: KnownUris.developer) {
                ContentRow(title: "app_info_developer_title", description: "app_info_developer_content")
            }

            ContentRow(
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
