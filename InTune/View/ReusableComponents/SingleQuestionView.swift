//
//  SingleQuestionView.swift
//  InTune
//
//  Created by Nancy Luu on 10/27/25.
//

import SwiftUI

struct SingleQuestionView: View {
    
    let question: String
    let options: [String]
    
    let currentQuestionIndex: Int
    let totalQuestions: Int
    
    let onBack: () -> Void
    let onNext: () -> Void
    
    let isFinalPage: Bool
    
    @State private var selectedIndices: Set<Int> = []
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack (alignment: .leading, spacing: 20){
                
                ZStack {
                    HStack(spacing: 8) {
                        ForEach(0..<totalQuestions, id: \.self) { index in
                            Circle()
                                .fill(index == currentQuestionIndex ? Color("MainColor") : Color("ButtonBackgroundColor"))
                                .frame(width: 10, height: 10)
                        }
                    }
                    
                    HStack {
                        NavigationButton(direction: .back, action: onBack)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                Text(question)
                    .font(.system(size: 27))
                    .foregroundStyle(Color("MainColor"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)

                FlowLayout(spacing: 10) {
                    ForEach(options.indices, id: \.self) { index in
                        PreferenceChip(
                            label: options[index],
                            isSelected: Binding(
                                get: { selectedIndices.contains(index) },
                                set: { newValue in
                                    if newValue {
                                        selectedIndices.insert(index)
                                    } else {
                                        selectedIndices.remove(index)
                                    }
                                }                            )
                        )
                    }
                }
                .padding(.horizontal, 20)
            
                HStack {
                    if isFinalPage {
                        Button(action: onNext) {
                            Text("Generate News")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal, 75)
                                .background(Color("MainColor"))
                                .cornerRadius(20)
                        }
                        .disabled(selectedIndices.isEmpty)
                        .opacity(selectedIndices.isEmpty ? 0.4 : 1.0)
                    } else {
                        Spacer()
                        NavigationButton(direction: .forward, action: onNext)
                            .disabled(selectedIndices.isEmpty)
                            .opacity(selectedIndices.isEmpty ? 0.4 : 1.0)
                    }
                
                }
                .padding()
                .padding(.horizontal, 25)
                
                Spacer()
            }
        }
    }
}


struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    SingleQuestionView(
        question: "How are you feeling right now?",
        options: ["😊 Happy / Positive", "😐 Neutral / Just browsing", "😟 Anxious / Worried", "🤔 Curious / Interested", "😴 Tired / Low energy"],
        currentQuestionIndex: 0,
        totalQuestions: 4,
        onBack: {
            print("Back tapped")
        },
        onNext: {
            print("Next tapped")
        },
        isFinalPage: false
    )
}



