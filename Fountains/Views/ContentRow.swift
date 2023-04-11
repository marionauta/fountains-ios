import SwiftUI

struct ContentRow: View {
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    init(title: LocalizedStringKey, description: LocalizedStringKey) {
        self.title = title
        self.description = description
    }

    init(title: LocalizedStringKey, description: String) {
        self.title = title
        self.description = LocalizedStringKey(description)
    }

    init(title: String, description: String) {
        self.title = LocalizedStringKey(title)
        self.description = LocalizedStringKey(description)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline.weight(.regular))
                .foregroundColor(.primary)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
