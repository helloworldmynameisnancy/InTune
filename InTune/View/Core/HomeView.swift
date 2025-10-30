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
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SavedArticlesViewModel())
}
