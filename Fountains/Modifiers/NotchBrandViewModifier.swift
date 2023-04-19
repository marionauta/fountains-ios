import SwiftUI

extension View {
    func withNotchBrand(_ title: LocalizedStringKey, backgroundColor: Color) -> some View {
        modifier(NotchBrandViewModifier(title: title, backgroundColor: backgroundColor))
    }
}

private struct NotchBrandViewModifier: ViewModifier {
    let title: LocalizedStringKey
    let backgroundColor: Color

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            if notchHeight > 24 {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .foregroundColor(.white)
                    .background(backgroundColor)
                    .cornerRadius(25)
                    .offset(y: offset)
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
    }

    var offset: CGFloat {
        switch notchHeight {
        case 0...47:
            return 6
        default:
            return 11
        }
    }

    var notchHeight: CGFloat = safeAreaTop()
}

private extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return (connectedScenes.first as? UIWindowScene)?.keyWindow
    }
}

private func safeAreaTop() -> CGFloat {
    if let window = UIApplication.shared.keyWindowInConnectedScenes {
        return window.safeAreaInsets.top
    }
    return 0
}
