import SwiftUI
import AVFoundation

struct LearningView: View {
    @StateObject private var viewModel = LearningViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    // Header
                    headerView
                        .padding(.top, 15)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 16) {
                        ForEach(viewModel.ipaSymbols, id: \.symbol) { ipaSymbol in
                            IPASymbolCard(
                                symbol: ipaSymbol,
                                onPlay: {
                                    viewModel.playSymbol(ipaSymbol)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                }
            }
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Nauka IPA")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            Text("Alfabet IPA")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Kliknij na symbol, aby usłyszeć jego wymowę")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct IPASymbolCard: View {
    let symbol: IPASymbol
    let onPlay: () -> Void
    
    var body: some View {
        Button(action: onPlay) {
            VStack(spacing: 12) {
                // IPA Symbol
                Text(symbol.symbol)
                    .font(.system(size: 48, weight: .bold, design: .serif))
                    .foregroundColor(.primary)
                
                // Description
                VStack(spacing: 6) {
                    Text(symbol.description)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(symbol.example)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // Phonetic transcription
                    Text(symbol.phoneticTranscription)
                        .font(.system(.caption, design: .monospaced))
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue.opacity(0.1))
                        )
                }
                .padding(.bottom, 2)
                
                // Play button
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    LearningView()
}
