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
    
    var enforceSingleSelection: Bool = false
    @Binding var singleSelectedIndex: Int?
    
    var disableOthersIfSelected: Set<String> = []
        
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack (alignment: .leading, spacing: 20){
                
                // Question Tracker and Back Button
                ZStack {
                    HStack(spacing: 8) {
                        ForEach(0..<totalQuestions, id: \.self) { index in
                            Circle()
                                .fill(index == currentQuestionIndex ? Color("MainColor") : Color("QuestionTrackerBackgroundColor"))
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
                    ForEach(Array(options.indices), id: \.self) { index in
                        let label = options[index]
                        
                        // Binding for chip selection
                        let chipBinding = Binding<Bool>(
                            get: {
                                enforceSingleSelection ? singleSelectedIndex == index : selectedIndices.contains(index)
                            },
                            set: { newValue in
                                if enforceSingleSelection {
                                    singleSelectedIndex = newValue ? index : nil
                                } else {
                                    if newValue { selectedIndices.insert(index) }
                                    else { selectedIndices.remove(index) }
                                }
                            }
                        )
                        
                        // Determine if chip should be disabled (grayed out)
                        let isDisabled: Bool = {
                            if enforceSingleSelection {
                                return singleSelectedIndex != nil && singleSelectedIndex != index
                            } else if !disableOthersIfSelected.isEmpty {
                                let selectedLabels = selectedIndices.map { options[$0] }
                                for special in disableOthersIfSelected {
                                    if selectedLabels.contains(special) && special != label {
                                        return true
                                    }
                                }
                            }
                            return false
                        }()
                        
                        // Determine visual selection: ignore selection if disabled
                        let isSelectedVisual: Bool = !isDisabled && (enforceSingleSelection ? singleSelectedIndex == index : selectedIndices.contains(index))
                        
                        PreferenceChip(
                            label: label,
                            isSelected: Binding(
                                get: { isSelectedVisual },
                                set: { newValue in
                                    chipBinding.wrappedValue = newValue
                                }
                            ),
                            isEnabled: !isDisabled
                        )
                    }
                }
                .padding(.horizontal, 20)
            
                // Forward Button or Generate Button
                HStack {
                    let isButtonDisabled: Bool = enforceSingleSelection
                        ? (singleSelectedIndex == nil)
                        : selectedIndices.isEmpty

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
                        .disabled(isButtonDisabled)
                        .opacity(isButtonDisabled ? 0.4 : 1.0)
                    } else {
                        Spacer()
                        NavigationButton(direction: .forward, action: onNext)
                            .disabled(isButtonDisabled)
                            .opacity(isButtonDisabled ? 0.4 : 1.0)
                    }
                }
                .padding()
                .padding(.horizontal, 25)
                
                Spacer()
            }
        }
    }
}

// Custom layout that arranges views in rows, wrapping to next line when needed (like flexbox)
struct FlowLayout: Layout {
    var spacing: CGFloat = 10
    
    // Calculates the total size needed for all subviews
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    // Positions each subview in the calculated layout
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    // Helper struct that calculates frame positions for flow layout
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                // If current item doesn't fit on line, wrap to next line
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                // Store frame for this subview
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            // Calculate total size
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct SingleQuestionView_PreviewWrapper: View {
    @State private var selectedMoodIndex: Int? = nil
    
    var body: some View {
        SingleQuestionView(
            question: "How are you feeling right now?",
            options: ["😊 Happy", "😐 Neutral", "😟 Anxious"],
            currentQuestionIndex: 0,
            totalQuestions: 4,
            onBack: {},
            onNext: {},
            isFinalPage: false,
            enforceSingleSelection: true,
            singleSelectedIndex: $selectedMoodIndex
        )
    }
}
