import enum DomainLayer.Secrets
import GoogleMobileAds
import SwiftUI

struct AdView: View {
    enum Stage {
        case loading, loaded, error
    }

    @State private var stage: Stage = .loading
    @State private var height: CGFloat = 80

    var body: some View {
        if stage == .error {
            EmptyView()
        } else {
            ZStack {
                if stage == .loading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                GeometryReader { proxy in
                    BannerView(stage: $stage, height: $height, width: proxy.size.width)
                }
                .frame(height: height)
            }
        }
    }
}

struct BannerView: UIViewControllerRepresentable {
    @Binding var stage: AdView.Stage
    @Binding var height: CGFloat
    var width: CGFloat
    private let bannerView = GADBannerView()
    private let adUnitID = Secrets.admobAdUnitId

    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = UIViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard stage != .error else { return }
        bannerView.adSize = GADInlineAdaptiveBannerAdSizeWithWidthAndMaxHeight(width, 80)
        bannerView.load(GADRequest())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        let parent: BannerView

        init(_ parent: BannerView) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            parent.stage = .loaded
            parent.height = bannerView.frame.height
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print(#function, error.localizedDescription)
            parent.stage = .error
        }
    }
}
