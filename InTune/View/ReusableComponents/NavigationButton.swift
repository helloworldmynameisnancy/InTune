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
                return "chevron.right"
            case .back:
                return "chevron.left"
            }
        }
    }
    
    let direction: Direction
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
                
                Image(systemName: direction.iconName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color("MainColor"))
            }
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
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
