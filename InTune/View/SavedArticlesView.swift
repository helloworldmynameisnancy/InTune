//
//  SavedArticlesView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/27/25.
//

import SwiftUI

struct SavedArticlesView: View {
    @State private var viewModel = SavedArticlesViewModel()
    
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
                                    ArticleCard(
                                        article: article,
                                        isBookmarked: viewModel.isArticleSaved(article),
                                        onBookmarkToggle: { article in
                                            viewModel.toggleBookmark(for: article)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SavedArticlesView()
}
