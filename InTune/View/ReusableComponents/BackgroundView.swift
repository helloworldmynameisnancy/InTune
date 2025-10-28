//
//  BackgroundView.swift
//  InTune
//
//  Created by Nancy Luu on 10/26/25.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color("MainColor")
                .ignoresSafeArea()
            
            Color("SecondColor")
                .cornerRadius(50)
                .padding(.top, -52)
                .padding(.horizontal, 8)
                .padding(.bottom, -73)
        }
    }
}

#Preview {
    BackgroundView()
}
