import SwiftUI

struct ArticleCard: View {
    let article: Article
    let isBookmarked: Bool
    var onBookmarkToggle: ((Article) -> Void)? = nil
    var onTap: ((Article) -> Void)? = nil
    
    init(article: Article, isBookmarked: Bool, onBookmarkToggle: ((Article) -> Void)? = nil, onTap: ((Article) -> Void)? = nil) {
        self.article = article
        self.isBookmarked = isBookmarked
        self.onBookmarkToggle = onBookmarkToggle
        self.onTap = onTap
    }

    var body: some View {
        Button {
            print("🖱️ ArticleCard tapped for: \(article.displayTitle)")
            onTap?(article)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                // MARK: - Article Image
                if let imageURL = article.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "newspaper")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("MainColor"))
                    }
                    .frame(width: 80, height: 80)
                    .clipped()
                    .background(Color("MainColor").opacity(0.1))
                    .cornerRadius(12)
                } else {
                    // Fallback to newspaper icon if no image URL
                    Image(systemName: "newspaper")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .padding(10)
                        .background(Color("MainColor").opacity(0.1))
                        .foregroundColor(Color("MainColor"))
                        .cornerRadius(12)
                }

                // MARK: - Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.category ?? "General")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(article.displayTitle)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(article.displayAuthor)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

                // MARK: - Bookmark Button
                Button {
                    onBookmarkToggle?(article)
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
        .buttonStyle(PlainButtonStyle()) // Prevents button styling from affecting the card
    }
}

#Preview {
    VStack(spacing: 16) {
        ArticleCard(article: Article.mockArticle1, isBookmarked: false)
        ArticleCard(article: Article.mockArticle2, isBookmarked: true)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
