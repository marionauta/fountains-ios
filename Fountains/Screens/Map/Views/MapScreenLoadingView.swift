import SwiftUI

extension MapScreen {
    struct LoadingView: View {
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                    Text("map_loadingview_title")
                    Spacer()
                }
                .background(.background)
                .cornerRadius(4)
                .shadow(radius: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}
