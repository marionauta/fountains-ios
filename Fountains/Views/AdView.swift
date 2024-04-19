import AdmobSwiftUI
import Perception
import SwiftUI

struct AdView: View {
    @Environment(PurchaseManager.self) private var purchaseManager

    let adUnit: String

    var body: some View {
        WithPerceptionTracking {
            if purchaseManager.hasRemovedAds {
                EmptyView()
            } else {
                BannerAdView(adUnitId: adUnit)
            }
        }
    }
}
