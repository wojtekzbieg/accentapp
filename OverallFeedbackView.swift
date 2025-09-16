import SwiftUI

struct OverallFeedbackView: View {
    let scores: PronunciationScores
    let onClose: () -> Void
    let onWordTap: (Int) -> Void
    
    var body: some View {
        VStack {
            // Overall score
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(scores.overallScore) / 100)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(scores.overallScore))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Text("Overall Score")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 15)
            .padding(.bottom, 10)
            
            ScrollView{
                // Clickable text with pronunciation scores
                VStack(spacing: 16) {
                    Text("Click on any word to see detailed feedback")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    // Display all words as clickable buttons
                    if let words = scores.words {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 80), spacing: 8)
                        ], spacing: 15) {
                            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                                Button(action: {
                                    onWordTap(index)
                                }) {
                                    VStack(spacing: 4) {
                                        Text(word.word ?? "")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                        
                                        Text("\(Int(word.accuracyScore))%")
                                            .font(.caption)
                                            .foregroundColor(scoreColorForWord(word.accuracyScore))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(scoreColorForWord(word.accuracyScore).opacity(0.6), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 30)
            }

            // Audio controls
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Coach")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                }
                
                Button(action: {}) {
                    Image(systemName: "tortoise.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(20)
                }
                
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("You")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                }
            }
            .padding(.bottom, 20)
            .padding(.top, 12)
            
            // Close button
            Button(action: onClose) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Helper Properties
    private var scoreColor: Color {
        switch scores.overallScore {
        case 90...100: return .green
        case 80..<90: return .yellow
        case 70..<80: return .orange
        default: return .red
        }
    }
    
    private func scoreColorForWord(_ score: Double) -> Color {
        switch score {
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
        
        OverallFeedbackView(
            scores: SampleData.samplePronunciationScores,
            onClose: { print("Close") },
            onWordTap: { index in print("Word tapped: \(index)") }
        )
    }
}
