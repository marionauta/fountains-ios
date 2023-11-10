import CommonLayer
import DomainLayer
import SwiftUI

struct AppInfoScreen: View {
    enum Constants {
        static let mapDistanceKey: String = "mapMaxDistanceInMeters"
        static let minMapDistance: Double = 5_000
        static let maxMapDistance: Double = 50_000
        static let mapDistanceRange = minMapDistance...maxMapDistance
    }

    @State private var isEasterShown: Bool = false
    @AppStorage(AdView.Constants.adsHiddenKey) private var areAdsHidden: Bool = false
    @AppStorage(Constants.mapDistanceKey) private var mapMaxDistance: Double = 15_000
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                VStack {
                    ContentRow(
                        title: "app_info_max_distance_title \(Measurement(value: mapMaxDistance, unit: UnitLength.meters), format: .measurement(width: .abbreviated))",
                        description: "app_info_max_distance_description"
                    )
                    HStack {
                        Text(Measurement(value: Constants.minMapDistance, unit: UnitLength.meters).formatted())
                        Slider(value: $mapMaxDistance, in: Constants.mapDistanceRange, step: 1_000)
                        Text(Measurement(value: Constants.maxMapDistance, unit: UnitLength.meters).formatted())
                    }
                }
            }
            Section {
                NavigationLink {
                    RoadmapCoordinator()
                } label: {
                    ContentRow(title: "roadmap_title", description: "roadmap_subtitle")
                }
            }

            Section("app_info_about_section") {
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
