import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
            ZStack {
                // Background
                Color(.systemBackground)
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
//                    headerSection
                    Text("Practice Your Pronunciation")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                        .padding(.top, 30)
                        .padding(.leading, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Main content
                    if viewModel.scores == nil {
                        practiceView
                    } else {
                        feedbackView
                    }
                }
        }
        .onDisappear { 
            viewModel.resetAssessment()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                // Settings action
            }) {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        
            Spacer()
            
            Text("Practice Your Pronunciation")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Close action
            }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Practice View
    private var practiceView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Coach message (hidden when keyboard is open)
            if !isTextFieldFocused {
                coachMessageView
            }
            
            Spacer()
            
            // Text input section
            textInputSection
            
            // Audio controls
            audioControlsView
            
            Spacer()
            
            // Record button
            recordButton
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }
    
    // MARK: - Feedback View
    private var feedbackView: some View {
        Group {
            if viewModel.showDetailedFeedback {
                DetailedFeedbackView(
                    scores: viewModel.scores!,
                    currentWord: viewModel.currentWord,
                    currentWordIndex: viewModel.currentWordIndex,
                    onClose: {
                        viewModel.showDetailedFeedback = false
                    },
                    onPreviousWord: {
                        viewModel.previousWord()
                    },
                    onNextWord: {
                        viewModel.nextWord()
                    },
                    onWordSelected: { index in
                        viewModel.selectWord(at: index)
                    }
                )
            } else {
                OverallFeedbackView(
                    scores: viewModel.scores!,
                    onClose: {
                        viewModel.resetAssessment()
                    },
                    onWordTap: { index in
                        viewModel.selectWord(at: index)
                    }
                )
            }
        }
    }
    
    // MARK: - Coach Message
    private var coachMessageView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Coach Eliza")
                .font(.subheadline)
                .foregroundColor(.green)
            
            HStack {
                Text("Let's begin! Record yourself saying the phrase below.")
                    .font(.body)
                    .foregroundColor(.white)
                    
                Spacer()
                    
                Circle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    )
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
    
    
    // MARK: - Text Input Section
    private var textInputSection: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .center) {
                TextField("", text: $viewModel.referenceText)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2...4)
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.4), lineWidth: 1.2)
                    )
                    .cornerRadius(12)
                    .accentColor(.white)
                    .focused($isTextFieldFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        // Hide keyboard when Return/Done is pressed
                        isTextFieldFocused = false
                    }
                
                if viewModel.referenceText.isEmpty && !isTextFieldFocused {
                    Text("Enter text to practice...")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.4))
                        .multilineTextAlignment(.center)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Audio Controls
    private var audioControlsView: some View {
        Button(action: {
            // Play reference audio
        }) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.title)
                .foregroundColor(.white)
                .padding(16)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Record Button
    private var recordButton: some View {
        Button(action: {
            if viewModel.isRunning {
                viewModel.resetAssessment()
            } else {
                viewModel.startAssessment()
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        viewModel.isButtonDisabled ? 
                        LinearGradient(colors: [.gray, .gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: viewModel.isRunning ? "stop.fill" : "mic.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .disabled(viewModel.isButtonDisabled)
        .scaleEffect(viewModel.isRunning ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isRunning)
    }
    
    
    
    
    
}

#Preview {
    ExerciseView()
}
