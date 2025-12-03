//
//  ArticleDetailView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @EnvironmentObject var viewModel: SavedArticlesViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isBookmarked: Bool
    @State private var showSafari = false
    
    init(article: Article) {
        self.article = article
        self._isBookmarked = State(initialValue: false)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    // MARK: - Pinned Header
                    HStack {
                        NavigationButton(direction: .back) {
                            dismiss()
                        }
                        .padding(.leading, 20)
                        .padding(.top, 8)
                        
                        Spacer()
                        
                        Button {
                            isBookmarked.toggle()
                            viewModel.toggleBookmark(for: article)
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color("MainColor"))
                            }
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 8)
                    }
                    
                    // MARK: - Scrollable Article Content
                    ScrollView {
                        VStack(spacing: 0) {
                            // Metadata
                            VStack(alignment: .leading, spacing: 16) {
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
                                
                                Text(article.displayTitle)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
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
                            .padding(.top, 16)
                            
                            // Image
                            if let imageURL = article.imageURL {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: geometry.size.width - 40)
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
                                .frame(maxWidth: geometry.size.width - 40, maxHeight: 200)
                                .clipped()
                                .cornerRadius(12)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(maxWidth: geometry.size.width - 40, maxHeight: 120)
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
                            
                            // Content
                            VStack(alignment: .leading, spacing: 20) {
                                if let content = article.content, !content.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Full Text")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text(content)
                                            .font(.body)
                                            .lineSpacing(4)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                
                                if article.articleURL != nil {
                                    VStack(spacing: 12) {
                                        Divider()
                                            .padding(.vertical, 8)
                                        
                                        Button {
                                            showSafari = true
                                        } label: {
                                            HStack {
                                                Image(systemName: "safari")
                                                Text("View Original Article")
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
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 40)
                        }
                        // constraints to prevent article from intruding into background view space
                        .frame(width: geometry.size.width)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isBookmarked = viewModel.isArticleSaved(article)
        }
        .onChange(of: viewModel.savedArticles) {
            isBookmarked = viewModel.isArticleSaved(article)
        }
        .sheet(isPresented: $showSafari) {
            if let url = article.articleURL {
                SafariView(url: url)
            }
        }
    }
    
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
