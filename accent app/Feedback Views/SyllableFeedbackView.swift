import SwiftUI

struct SyllableFeedbackView: View {
    let syllable: SyllableResult
    
    var body: some View {
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
            
            Text("\(Int(syllable.accuracyScore))%")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(scoreColor.opacity(0.3))
                .cornerRadius(16)
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
            SyllableFeedbackView(syllable: SampleData.sampleWords[0].syllables[0])
            SyllableFeedbackView(syllable: SampleData.sampleWords[0].syllables[1])
        }
        .padding()
    }
}
