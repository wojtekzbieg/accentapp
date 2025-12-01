import SwiftUI

struct SentenceFeedbackView: View {
    let words: [String]
    let currentWordIndex: Int
    let onWordSelected: (Int) -> Void
    let scores: PronunciationScores?
    
    var body: some View {
        VStack(spacing: 20) {
            // Word bubbles with horizontal scrolling
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                        Button(action: {
                            onWordSelected(index)
                        }) {
                            Text(word)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(wordColor(for: index))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(backgroundColor(for: index))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(borderColor(for: index), lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Helper Functions
    private func wordColor(for index: Int) -> Color {
        return scoreColor(for: index)
    }
    
    private func backgroundColor(for index: Int) -> Color {
        return .gray.opacity(0.2)
    }
    
    private func borderColor(for index: Int) -> Color {
        if index == currentWordIndex {
            return .white
        } else {
            return .clear
        }
    }
    
    private func scoreColor(for index: Int) -> Color {
        guard let scores = scores,
              let words = scores.words,
              index < words.count else {
            return .gray
        }
        
        let wordScore = words[index].accuracyScore
        
        switch wordScore {
        case 90...100: return .green
        case 80..<90: return .yellow
        case 70..<80: return .orange
        default: return .red
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        SentenceFeedbackView(
            words: SampleData.sampleWordsArray,
            currentWordIndex: 2,
            onWordSelected: { index in
                print("Selected word at index: \(index)")
            },
            scores: SampleData.samplePronunciationScores
        )
    }
}
