import AdmobSwiftUI
import enum DomainLayer.Secrets
import HelperKit
import SwiftUI

struct AdView: View {
    enum Constants {
        static let adsHiddenKey = "ADSHIDDEN.\(Bundle.main.buildNumber)"
    }

    let adUnit: String

    var body: some View {
        BannerAdView(adUnitId: adUnit, adsHiddenKey: Constants.adsHiddenKey)
    }
}
