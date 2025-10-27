import SwiftUI

struct ArticleCard: View {
    // Hardcoded placeholder content for now
    let category = "Technology"
    let title = "Apple, Google, Meta must face lawsuits over casino-style gambling apps"
    let author = "Bart Jansen"

    @State private var isBookmarked = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // MARK: - Icon Image
            Image(systemName: "newspaper")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(10)
                .background(Color("MainColor").opacity(0.1))
                .foregroundColor(Color("MainColor"))
                .cornerRadius(12)

            // MARK: - Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(author)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            // MARK: - Bookmark Button
            Button {
                isBookmarked.toggle()
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(isBookmarked ? Color("MainColor") : .gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 16) {
        ArticleCard()
        ArticleCard()
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
