import SwiftUI

struct NeedsLocationBannerView: View {
    let isLocationEnabled: Bool
    
    var body: some View {
        if isLocationEnabled {
            EmptyView()
        } else {
            Text("map_location_disabled")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .foregroundStyle(Color.white)
                .background(Color.black)
                .onTapGesture {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                }
        }
    }
}
