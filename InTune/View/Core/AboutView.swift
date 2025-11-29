//
//  AboutView.swift
//  InTune
//
//  Created by Nancy Luu on 10/26/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack (alignment: .leading, spacing: 20){
                HStack {
                    Text("About")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("ꙆᥒƮᥙᥒᥱ")
                        .font(.system (size: 35))
                }
                .padding(.top, 30)
                
                Text("InTune’s mission is to transform news consumption, keeping users informed while supporting their mental well-being.")
                    .italic()
                    .font(.system (size: 20))
                    .fontWeight(.semibold)
                    .padding(.top, 10)
                
                Text(
                    "In a world overflowing with information, most platforms prioritize quantity over meaningful, personalized content, often leading to doomscrolling and a disconnection from stories that truly matter. That’s why we recommend just \(Text("four carefully curated items").bold())—enough to stay aware without feeling overloaded or stressed."
                )
                .font(.system (size: 20))
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            
        }
    }
}

#Preview {
    AboutView()
}
