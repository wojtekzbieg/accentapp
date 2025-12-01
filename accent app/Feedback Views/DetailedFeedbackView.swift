import SwiftUI

struct DetailedFeedbackView: View {
    let scores: PronunciationScores
    let currentWord: String
    let currentWordIndex: Int
    let onClose: () -> Void
    let onPreviousWord: () -> Void
    let onNextWord: () -> Void
    let onWordSelected: (Int) -> Void
    let viewModel: ExerciseViewModel
    
    var body: some View {
      
            VStack {
                // Close button
//                HStack {
//                    Spacer()
//                    Button(action: onClose) {
//                        Image(systemName: "xmark")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(8)
//                            .background(Color.gray.opacity(0.3))
//                            .clipShape(Circle())
//                    }
//                }
//                .padding(.horizontal, 20)
                
                // Sentence with word highlighting
                if let words = scores.words {
                    let wordStrings = words.compactMap { $0.word }
                    SentenceFeedbackView(
                        words: wordStrings,
                        currentWordIndex: currentWordIndex,
                        onWordSelected: onWordSelected,
                        scores: scores
                    )
                    .padding(.bottom, 10)
                }
                
                ScrollView {
                    // Word analysis
                    VStack(spacing: 16) {
                        // Overall score for current word
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(wordScore) / 100)
                                .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int(wordScore))%")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Text(currentWord)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(phoneticText)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    
                    // Audio controls
                    HStack(spacing: 16) {
                        Button(action: {
                            // Play current word with Coach voice (normal speed)
                            viewModel.playTextToSpeech(text: currentWord)
                        }) {
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
                        
                        Button(action: {
                            // Play current word with slow speed
                            viewModel.playTextToSpeech(text: currentWord, rate: 0.01)
                        }) {
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
                    .padding(.top, 10)
                    
                    // Syllable breakdown
                    if let words = scores.words, currentWordIndex < words.count {
                        let word = words[currentWordIndex]
                        VStack(spacing: 12) {
                            ForEach(Array(word.syllables.enumerated()), id: \.offset) { _, syllable in
                                DetailedSyllableView(syllable: syllable)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                
                // Navigation buttons
                HStack(spacing: 20) {
                    Button(action: onPreviousWord) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: onClose) {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: onNextWord) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 8)
            }
        
        .background(Color.black)
    }
    
    // MARK: - Helper Properties
    private var wordScore: Double {
        guard let words = scores.words, currentWordIndex < words.count else { return 0 }
        return words[currentWordIndex].accuracyScore
    }
    
    private var phoneticText: String {
        guard let words = scores.words, currentWordIndex < words.count else { return "" }
        let word = words[currentWordIndex]
        
        // Combine syllables to create phonetic representation
        let phoneticSyllables = word.syllables.compactMap { syllable in
            // Prefer syllable over grapheme, but use grapheme as fallback
            syllable.syllable ?? syllable.grapheme
        }
        
        // Join with dots for better readability
        let phoneticString = phoneticSyllables.joined(separator: ".")
        
        // If we have phonetic data, return it with IPA formatting, otherwise return a placeholder
        if phoneticString.isEmpty {
            return "No phonetic data"
        } else {
            // Format as IPA with brackets for clarity
            return "/\(phoneticString)/"
        }
    }
    
    private var scoreColor: Color {
        switch wordScore {
        case 90...100: return .green
        case 80..<90: return .yellow
        case 70..<80: return .orange
        default: return .red
        }
    }
}

#Preview {
    DetailedFeedbackView(
        scores: SampleData.samplePronunciationScores,
        currentWord: "looking",
        currentWordIndex: 2,
        onClose: { print("Close detailed view") },
        onPreviousWord: { print("Previous word") },
        onNextWord: { print("Next word") },
        onWordSelected: { index in print("Word selected: \(index)") },
        viewModel: ExerciseViewModel()
    )
}
