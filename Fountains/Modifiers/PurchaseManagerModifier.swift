import SwiftUI

struct PurchaseManagerModifier: ViewModifier {
    @State private var purchaseManager = PurchaseManager()

    func body(content: Content) -> some View {
        content
            .environment(purchaseManager)
            .task {
                async let products: Void = purchaseManager.retrieveProducts()
                async let purchases: Void = purchaseManager.updatePurchasedProducts()
                _ = await (products, purchases)
            }
    }
}
