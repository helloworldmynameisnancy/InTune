//
//  NavigationButton.swift
//  InTune
//
//  Created by Nancy Luu on 10/28/25.
//

import SwiftUI

struct NavigationButton: View {
    enum Direction {
        case forward
        case back
        
        var iconName: String {
            switch self {
            case .forward:
                return "arrow.right"
            case .back:
                return "arrow.left"
            }
        }
    }
    
    let direction: Direction
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color("ButtonBackgroundColor"))
                    .frame(width: 30, height: 30)
                
                Image(systemName: direction.iconName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color("ButtonArrowColor"))
            }
        }
    }
}

#Preview {
    NavigationButton(direction: .forward, action: {
        print("Forward pressed")
    })
    
    NavigationButton(direction: .back, action: {
        print("Back pressed")
    })
}
