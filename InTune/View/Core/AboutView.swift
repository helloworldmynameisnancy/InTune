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
            
            VStack (alignment: .leading, spacing: 15){
                Text("About ꙆᥒƮᥙᥒᥱ")
                    .font(.system(size: 48))
                
                Text("Re-imagining news consumption")
                    .italic()
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                
                Text(
                    "In a world overflowing with information, most platforms prioritize quantity over meaningful, personalized content, this often leads to doomscrolling, stress, and disconnection from stories that truly matter. \(Text("InTune’s mission is to transform news consumption, keeping users informed while supporting their mental well-being").bold()). That’s why we recommend just \(Text("four carefully curated items").bold())—enough to stay aware without feeling overwhelmed. Users can personalize their feed from one to seven items, a range we intentionally limit because exceeding it often reduces focus and increases stress. Every choice in InTune is guided by the belief that content should \(Text("inform, not overwhelm").bold()), giving users space to connect with what matters."
                )

                    .font(.system(size: 20))
            }
            .padding(.horizontal, 30)
            
        }
    }
}

#Preview {
    AboutView()
}
