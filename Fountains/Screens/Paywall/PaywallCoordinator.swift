import SwiftUI

struct PaywallCoordinator: View {
    @Environment(PurchaseManager.self) private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismissAction: DismissAction

    var body: some View {
        NavigationView {
            if #available(iOS 17.0, *) {
                PaywallScreen()
                    .toolbar { toolbarContent }
                    .environment(purchaseManager)
            } else {
                Color.clear
                    .task {
                        dismissAction()
                    }
            }
        }
        .modifier(HalfSheetModifier())
    }

    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("paywall_coordinator_close_button_label") {
                dismissAction()
            }
        }
    }
}
