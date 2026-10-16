import SwiftUI

struct TagChipsView: View {
    let tags: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.caption.weight(.medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.tint.opacity(0.15), in: .capsule)
                        .foregroundStyle(.tint)
                }
            }
        }
    }
}

#Preview {
    TagChipsView(tags: ["biology", "plants", "energy"])
        .padding()
}
