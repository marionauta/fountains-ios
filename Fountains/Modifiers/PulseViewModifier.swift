import Pulse
import PulseUI
import SwiftUI

extension View {
    func withPulse() -> some View {
        #if DEBUG
        modifier(PulseViewModifier())
        #else
        self
        #endif
    }
}

#if DEBUG
private struct PulseViewModifier: ViewModifier {
    @State private var showPulse: Bool = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                URLSessionProxyDelegate.enableAutomaticRegistration()
            }
            .onShake {
                showPulse = true
            }
            .sheet(isPresented: $showPulse) {
                NavigationView {
                    ConsoleView()
                }
            }
    }
}
#endif
