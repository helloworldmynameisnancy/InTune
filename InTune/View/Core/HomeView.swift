//
//  HomeView.swift
//  
//
//  Created by Nancy Luu on 10/26/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var savedViewModel: SavedArticlesViewModel
    
    var body: some View {
        NavigationStack() {
            ZStack {
                
                BackgroundView()
                
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 187, height: 231)
                    
                    Text("ꙆᥒƮᥙᥒᥱ")
                        .font(.system(size: 50))
                        .padding(.top, -20)
                    
                    Text("News curated just for you.")
                        .font(.system(size: 16))
                        .padding(.top, 1)
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: MoodView()) {
                        Text("Tune Me In")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal, 75)
                            .background(Color("MainColor"))
                            .cornerRadius(20)
                    }
                    
                    // TEMPORARY: API Test Button (remove after testing)
                    Button {
                        Task {
                            let service = NewsAPIAIService()
                            do {
                                let success = try await service.testConnection()
                                print(success ? "\n✅✅✅ API TEST SUCCESSFUL! ✅✅✅\n" : "\n❌❌❌ API TEST FAILED ❌❌❌\n")
                            } catch {
                                print("\n❌❌❌ API TEST ERROR: \(error.localizedDescription) ❌❌❌\n")
                            }
                        }
                    } label: {
                        Text("🧪 Test API Connection")
                            .font(.system(size: 14))
                            .foregroundStyle(.blue)
                            .padding(.top, 10)
                    }
                }
            }
        }
        .onAppear {
            // Auto-test API on app launch (check console)
            Task {
                print("\n🚀 Starting API connection test...\n")
                let service = NewsAPIAIService()
                do {
                    let success = try await service.testConnection()
                    print(success ? "\n✅✅✅ API TEST SUCCESSFUL! ✅✅✅\n" : "\n❌❌❌ API TEST FAILED ❌❌❌\n")
                } catch {
                    print("\n❌❌❌ API TEST ERROR: \(error.localizedDescription) ❌❌❌\n")
                    // end of test
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SavedArticlesViewModel())
}
