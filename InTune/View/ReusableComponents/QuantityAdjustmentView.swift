//
//  QuantityAdjustmentView.swift
//  InTune
//
//  Created by Diana Nguyen on 10/28/25.
//

import SwiftUI

struct QuantityAdjustmentView: View {
    @Binding var quantity: Int
    var onUpdate: (Int) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 8) {
                    Text("Articles Per Feed")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Choose how many articles to display")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Quantity Selection Buttons
                HStack(spacing: 16) {
                    ForEach([3, 4, 5], id: \.self) { option in
                        Button {
                            quantity = option
                            onUpdate(option)
                        } label: {
                            Text("\(option)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(quantity == option ? .white : Color("MainColor"))
                                .frame(width: 60, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(quantity == option ? Color("MainColor") : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color("MainColor"), lineWidth: 2)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Done Button
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color("MainColor"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color(.systemBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    QuantityAdjustmentView(
        quantity: .constant(4),
        onUpdate: { newQuantity in
        }
    )
}
