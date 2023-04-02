import MapKit
import DomainLayer
import SwiftUI

struct AreaPreviewModal: View {
    let area: Area
    let onAdd: () -> Void

    var body: some View {
        VStack {
            Text(area.name)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            Map(coordinateRegion: .constant(previewMapRegion))
                .edgesIgnoringSafeArea(.bottom)
                .disabled(true)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("areas_add_add_button", action: onAdd)
            }
        }
    }

    private var previewMapRegion: MKCoordinateRegion {
        return MKCoordinateRegion(
            center: area.location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.03,
                longitudeDelta: 0.03
            )
        )
    }
}
