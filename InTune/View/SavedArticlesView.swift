//
//  SavedArticlesView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import SwiftUI

struct SavedArticlesView: View {
    @EnvironmentObject var viewModel: SavedArticlesViewModel
    @State private var selectedArticle: Article?
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Saved News")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("All of your saved news in one place.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Content Section
                    if viewModel.savedArticles.isEmpty {
                        // Empty State
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image(systemName: "bookmark")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                            
                            Text("Save news and view here.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Articles List
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.savedArticles) { article in
                                    let _ = print("📚 SavedArticlesView - Article: \(article.displayTitle)")
                                    let _ = print("📚 SavedArticlesView - Image URL: \(article.urlToImage ?? "nil")")
                                    let _ = print("📚 SavedArticlesView - Image URL object: \(article.imageURL?.absoluteString ?? "nil")")
                                    
                                    ArticleCard(
                                        article: article,
                                        isBookmarked: viewModel.isArticleSaved(article),
                                        onBookmarkToggle: { article in
                                            viewModel.toggleBookmark(for: article)
                                        },
                                        onTap: { article in
                                            print("🖱️ ArticleCard tapped - setting selectedArticle")
                                            selectedArticle = article
                                        }
                                    )
                                    .id(article.id)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedArticle) { article in
                print("🔗 NavigationDestination triggered for: \(article.displayTitle)")
                return ArticleDetailView(article: article)
            }
        }
    }
}

#Preview {
    SavedArticlesView()
        .environmentObject(SavedArticlesViewModel())
}
