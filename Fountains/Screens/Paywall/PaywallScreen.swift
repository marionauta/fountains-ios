import Perception
import StoreKit
import SwiftUI

@available(iOS 17.0, *)
struct PaywallScreen: View {
    @Environment(PurchaseManager.self) private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismissAction: DismissAction

    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack {
                    ProductFeatureText(title: "paywall_remove_ads_first")
                    ProductFeatureText(title: "paywall_remove_ads_second")
                    ProductFeatureText(title: "paywall_remove_ads_support_developer")

                    ProductView(id: ProductId.defaultPaywall.rawValue)
                        .productViewStyle(.large)
                        .padding(.vertical)
                        .onInAppPurchaseCompletion { _, result in
                            switch result {
                            case .success(.success(.verified)):
                                await purchaseManager.updatePurchasedProducts()
                                dismiss()
                            default:
                                break
                            }
                        }

                    Button("paywall_restore_purchases_button") {
                        Task { await restorePurchases() }
                    }
                    .font(.footnote)
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationTitle("paywall_title")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func restorePurchases() async {
        try? await AppStore.sync()
        await purchaseManager.updatePurchasedProducts()
        dismiss()
    }

    private func dismiss() {
        dismissAction()
    }
}

private struct ProductFeatureText: View {
    let title: LocalizedStringKey

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.orange.opacity(0.75))
                }

            Text(title)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

enum ProductId: String, CaseIterable, Identifiable {
    case premium1 = "mn.openlocations.premium1"
    var id: ProductId { self }
    static var defaultPaywall: ProductId {
        .premium1
    }
    var removesAds: Bool {
        switch self {
        case .premium1: true
        }
    }
    static var removeAds: Set<Self> = Set(allCases.filter(\.removesAds))
}

@Perceptible
final class PurchaseManager {
    public private(set) var availableProductIds: Set<ProductId> = []
    public private(set) var purchasedProductIds: Set<String> = []

    public var hasRemovedAds: Bool {
        !availableProductIds.contains(where: \.removesAds) || purchasedProductIds.hasRemovedAds
    }

    @MainActor
    public func retrieveProducts() async {
        guard let products = try? await Product.products(for: ProductId.allCases.map(\.rawValue)) else { return }
        availableProductIds = Set(products.compactMap { ProductId(rawValue: $0.id) })
    }

    public func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case let .verified(transaction) = result else { continue }
            if transaction.revocationDate == nil {
                purchasedProductIds.insert(transaction.productID)
            } else {
                purchasedProductIds.remove(transaction.productID)
            }
        }
    }
}

private extension Set<String> {
    var hasRemovedAds: Bool {
        let products = ProductId.removeAds.map(\.rawValue)
        return !intersection(products).isEmpty
    }
}
