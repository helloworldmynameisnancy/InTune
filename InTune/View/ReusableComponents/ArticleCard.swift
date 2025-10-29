import SwiftUI

struct AsyncImageLoader: View {
    let url: URL
    @State private var image: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                Image(systemName: "newspaper")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("MainColor"))
            } else {
                Image(systemName: "newspaper")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("MainColor"))
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data, let uiImage = UIImage(data: data) {
                    image = uiImage
                } else {
                }
            }
        }.resume()
    }
}

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
            onTap?(article)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                // MARK: - Article Image
                if let imageURL = article.imageURL {
                    AsyncImageLoader(url: imageURL)
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
        ArticleCard(
            article: Article(
                url: "https://example.com/preview1",
                source: Source(id: nil, name: "Preview Source"),
                author: "Preview Author",
                title: "Preview Article 1",
                description: "This is a preview article for testing the ArticleCard component",
                urlToImage: nil,
                publishedAt: "2025-01-01T00:00:00Z",
                content: "Preview content here"
            ),
            isBookmarked: false
        )
        ArticleCard(
            article: Article(
                url: "https://example.com/preview2",
                source: Source(id: nil, name: "Preview Source"),
                author: "Preview Author",
                title: "Preview Article 2",
                description: "This is another preview article for testing",
                urlToImage: nil,
                publishedAt: "2025-01-01T00:00:00Z",
                content: "More preview content"
            ),
            isBookmarked: true
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
