import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 10)
            AdView(adUnit: Secrets.admobMapAdUnitId).padding(.bottom, 4)
            NeedsLocationBannerView(isLocationEnabled: viewModel.hideLocationBanner)
            MapView(viewModel: viewModel)
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
        .overlay(alignment: .bottomTrailing) {
            tooFarAwayMessage
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task {
            viewModel.requestLocationAndCenter(requestIfneeded: false)
            await viewModel.load(from: nil)
        }
    }

    @ViewBuilder
    private var tooFarAwayMessage: some View {
        Text("map_too_far_away")
            .multilineTextAlignment(.leading)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.75))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .opacity(viewModel.isTooFarAway ? 1 : 0)
            .animation(.easeInOut, value: viewModel.isTooFarAway)
            .allowsHitTesting(false)
            .padding(.horizontal, 12)
            .padding(.bottom, 40)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(spacing: 4) {
                if let areaName = viewModel.areaName {
                    Text(areaName)
                }
                if let lastUpdated = viewModel.lastUpdated {
                    Text(lastUpdated.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isLoading {
                ProgressView().progressViewStyle(.circular)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                AppInfoScreen()
            } label: {
                AppInfoLabel()
            }
        }
    }
}
