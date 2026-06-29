import AdmobSwiftUI
import Perception
import SwiftUI

struct AdView: View {
    @Environment(PurchaseManager.self) private var purchaseManager

    let adUnit: String
    let onRemoveAds: (() -> Void)?

    init(adUnit: String, onRemoveAds: @escaping () -> Void) {
        self.adUnit = adUnit
        if #available(iOS 17, *) {
            self.onRemoveAds = onRemoveAds
        } else {
            self.onRemoveAds = nil
        }
    }

    var body: some View {
        WithPerceptionTracking {
            if purchaseManager.hasRemovedAds {
                EmptyView()
            } else {
                VStack(spacing: 0) {
                    BannerAdView(adUnitId: adUnit)
                    if let onRemoveAds {
                        RemoveAdsButton(action: onRemoveAds)
                    }
                }
            }
        }
    }
}

private struct RemoveAdsButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("remove_ads_button_label")
                .font(.caption)
                .padding(6)
                .frame(maxWidth: .infinity)
        }
    }
}
