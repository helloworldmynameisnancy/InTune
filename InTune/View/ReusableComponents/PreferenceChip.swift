//
//  PreferenceChip.swift
//  InTune
//
//  Created by Nancy Luu on 10/27/25.
//

import SwiftUI

struct PreferenceChip: View {
    
    let label: String
    @Binding var isSelected: Bool
    var isEnabled: Bool = true

    var body: some View {
        
        Button {
            isSelected.toggle()
        } label: {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(isSelected ? .white : .black)
                .padding(8)
                .background(
                    isSelected
                        ? Color("MainColor") : (isEnabled ? Color.white : Color.gray.opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? .black : Color("MainColor"), lineWidth: 2)
                )
                .cornerRadius(15)
                .opacity(isEnabled ? 1.0 : 0.4)
                
        }
        .disabled(!isEnabled)
    }
}

#Preview("Selected") {
    PreferenceChip(label: "😊 Happy / Positive", isSelected: .constant(false))
    PreferenceChip(label: "😊 Happy / Positive", isSelected: .constant(true))
        
}
