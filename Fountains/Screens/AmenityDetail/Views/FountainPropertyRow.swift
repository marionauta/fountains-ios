import SwiftUI

struct FountainPropertyRow: View {
    let name: LocalizedStringKey
    let description: LocalizedStringKey
    let value: LocalizedStringKey

    init(name: LocalizedStringKey, description: LocalizedStringKey, value: String) {
        self.name = name
        self.description = description
        self.value = LocalizedStringKey(value)
    }

    init(name: LocalizedStringKey, description: LocalizedStringKey, value: LocalizedStringKey) {
        self.name = name
        self.description = description
        self.value = value
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .bottom) {
                    Text(name)
                    Spacer()
                    Text(value)
                }
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            Divider()
        }
    }
}
