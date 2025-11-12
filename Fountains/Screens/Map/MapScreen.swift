import DomainLayer
import MapKit
import SwiftUI

struct MapScreen: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack(spacing: 0) {
            AdView(adUnit: Secrets.admobMapAdUnitId)
            NeedsLocationBannerView(isLocationEnabled: viewModel.hideLocationBanner)
            MapView(viewModel: viewModel)
        }
        .overlay(alignment: .bottomTrailing) {
            tooFarAwayMessage
        }
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
}
