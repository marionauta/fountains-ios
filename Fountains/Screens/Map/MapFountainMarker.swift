import DomainLayer
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
        Text(String(count))
            .foregroundStyle(Color.white)
            .frame(width: 25, height: 25)
            .background(Color(.marker))
            .clipShape(Circle())
            .padding(1.5)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 2, y: 2)
            .onTapGesture(perform: onTap)
    }
}
