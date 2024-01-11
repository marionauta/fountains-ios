import AdmobSwiftUI
import enum DomainLayer.Secrets
import HelperKit
import SwiftUI

struct AdView: View {
    enum Constants {
        static let adsHiddenKey = "ADSHIDDEN.\(Bundle.main.buildNumber)"
    }

    var body: some View {
        BannerAdView(adUnitId: Secrets.admobAdUnitId, adsHiddenKey: Constants.adsHiddenKey)
    }
}
