import DomainLayer
import MapCluster
import MapKit
import SwiftUI

struct MapFountainMarker: View {
    let onTap: () -> Void

    var body: some View {
        Image(.marker)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 2, y: 2)
            .onTapGesture(perform: onTap)
    }
}

struct MapClusterMarker: View {
    let count: Int
    let onTap: () -> Void

    var body: some View {
        DefaultClusterView(count: count)
            .tint(Color(.marker))
            .onTapGesture(perform: onTap)
    }
}
