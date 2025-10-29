//
//  ArticleDetailView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import SwiftUI
import SafariServices

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject var viewModel: SavedArticlesViewModel
    @State private var isBookmarked: Bool
    @State private var showSafari = false
    @Environment(\.dismiss) private var dismiss
    
    init(article: Article) {
        self.article = article
        self._isBookmarked = State(initialValue: false)
    }
    
    var body: some View {
        
        return ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Article Metadata Section
                    VStack(alignment: .leading, spacing: 16) {
                        // Source and Category
                        HStack {
                            Text(article.displaySource)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(article.category ?? "General")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Article Title
                        Text(article.displayTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                        
                        // Author and Date
                        HStack {
                            Text(article.displayAuthor)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            if let publishedAt = article.publishedAt {
                                Text(formatDate(publishedAt))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // MARK: - Article Image Section
                    if let imageURL = article.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        Text("Loading image...")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    } else {
                        // Placeholder for articles without images
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 120)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "newspaper")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("No image available")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            )
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                    
                    // MARK: - Article Content Section
                    VStack(alignment: .leading, spacing: 20) {
                        // Article Description
                        if let description = article.description, !description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Summary")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(description)
                                    .font(.body)
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        // Article Content
                        if let content = article.content, !content.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Full Article")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(content)
                                    .font(.body)
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        // Read Full Article Button
                        if article.articleURL != nil {
                            VStack(spacing: 12) {
                                Divider()
                                    .padding(.vertical, 8)
                                
                                Button {
                                    // Open in SFSafariViewController
                                    showSafari = true
                                } label: {
                                    HStack {
                                        Image(systemName: "safari")
                                            .font(.system(size: 16))
                                        Text("Read Full Article")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color("MainColor"))
                                    .cornerRadius(12)
                                }
                                
                                Text("Opens in Safari")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .onAppear {
                            }
                        } else {
                            Text("")
                                .onAppear {
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Toggle bookmark
                    isBookmarked.toggle()
                    viewModel.toggleBookmark(for: article)
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
        .onAppear {
            // Check initial bookmark state when view appears
            isBookmarked = viewModel.isArticleSaved(article)
        }
        .onChange(of: viewModel.savedArticles) {
            // React to changes in saved articles from other views
            isBookmarked = viewModel.isArticleSaved(article)
        }
        .sheet(isPresented: $showSafari) {
            if let articleURL = article.articleURL {
                SafariView(url: articleURL)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

// MARK: - SafariView Wrapper

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    ArticleDetailView(
        article: Article(
            url: "https://example.com/preview-detail",
            source: Source(id: nil, name: "Preview Source"),
            author: "Preview Author",
            title: "Preview Article for Detail View",
            description: "This is a preview article for testing the ArticleDetailView component",
            urlToImage: nil,
            publishedAt: "2025-01-01T00:00:00Z",
            content: "This is the full content of the preview article for testing purposes."
        )
    )
    .environmentObject(SavedArticlesViewModel())
}