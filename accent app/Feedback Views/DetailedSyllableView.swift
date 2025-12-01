import SwiftUI

struct DetailedSyllableView: View {
    let syllable: SyllableResult
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {}) {
                    HStack(spacing: 8) {
                        Text(syllable.syllable ?? syllable.grapheme ?? "-")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("\(Int(syllable.accuracyScore))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    if syllable.accuracyScore >= 90 {
                        Text("Awesome!")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else if syllable.accuracyScore >= 80 {
                        Text("Good!")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    } else {
                        Text("Needs work")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(scoreColor.opacity(0.3))
                .cornerRadius(16)
            }
            
            // Additional feedback buttons
            if syllable.accuracyScore < 90 {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.circle")
                                .font(.caption)
                            Text("Explain My Mistake")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "mouth")
                                .font(.caption)
                            Text("Compare Sounds")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var scoreColor: Color {
        switch syllable.accuracyScore {
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
        
        VStack(spacing: 12) {
            DetailedSyllableView(syllable: SampleData.sampleWords[2].syllables[0])
            DetailedSyllableView(syllable: SampleData.sampleWords[2].syllables[1])
            DetailedSyllableView(syllable: SampleData.sampleWords[2].syllables[2])
        }
        .padding()
    }
}
