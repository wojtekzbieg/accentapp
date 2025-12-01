import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("Practice Your Pronunciation")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .padding(.top, 30)
                    .padding(.leading, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Mode picker
                modePicker
                    .padding(.top, 10)
                
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
    
    // MARK: - Mode Picker
    private var modePicker: some View {
        Picker("Tryb", selection: Binding(
            get: { viewModel.mode },
            set: { newMode in
                isTextFieldFocused = false
                viewModel.selectMode(newMode)
            }
        )) {
            Text(ExerciseMode.manual.title).tag(ExerciseMode.manual)
            Text(ExerciseMode.fixed.title).tag(ExerciseMode.fixed)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .accessibilityIdentifier("exerciseModePicker")
    }
    
    // MARK: - Practice View
    private var practiceView: some View {
        VStack(spacing: isTextFieldFocused ? 20 : 30) {
            Spacer()
            
            // Coach message (hidden when keyboard is open)
            if !isTextFieldFocused {
                coachMessageView
            }
            
            Spacer()
            
            // Text input section
            textInputSection
            
            // Audio controls (hidden when keyboard is open)
            if !isTextFieldFocused {
                audioControlsView
            }
            
            Spacer()
            
            // Record button – zawsze widoczny, ale wyżej gdy klawiatura otwarta
            recordButton
                .padding(.bottom, isTextFieldFocused ? 20 : 40)
        }
        .padding(.horizontal, 20)
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
                    },
                    viewModel: viewModel
                )
            } else {
                OverallFeedbackView(
                    scores: viewModel.scores!,
                    onClose: {
                        viewModel.resetAssessment()
                    },
                    onWordTap: { index in
                        viewModel.selectWord(at: index)
                    },
                    viewModel: viewModel
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
            
            HStack(alignment: .center, spacing: 15) {
                Text(coachMessageText)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                
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
    
    private var coachMessageText: String {
        switch viewModel.mode {
        case .manual:
            return "Let's begin! Record yourself saying the phrase below."
        case .fixed:
            return "Powtarzaj tongue twister poniżej. To świetne ćwiczenie na wymowę!"
        }
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
//                    .lineLimit(2...4)
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
                        isTextFieldFocused = false
                    }
                    .disabled(viewModel.mode == .fixed)
                    .opacity(viewModel.mode == .fixed ? 0.85 : 1.0)
                
                if viewModel.referenceText.isEmpty && !isTextFieldFocused && viewModel.mode == .manual {
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
        HStack(spacing: 0) {
            // Play button (lewa strona)
            Button(action: {
                viewModel.playTextToSpeech()
            }) {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(10)
            }
            
            // Separator line (tylko w trybie fixed)
            if viewModel.mode == .fixed {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1, height: 25)
                    .padding(.horizontal, 8)
                
                // Shuffle button (prawa strona)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.getNewTongueTwister()
                    }
                }) {
                    Image(systemName: "shuffle")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(10)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
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
                if viewModel.isButtonDisabled {
                    Circle()
                        .fill(LinearGradient(colors: [.gray, .gray], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                } else {
                    Circle()
                        .fill(LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .shadow(color: .pink.opacity(0.2), radius: 12, x: -3, y: -6)
                        .shadow(color: .orange.opacity(0.2), radius: 12, x: 3, y: 6)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: viewModel.isRunning ? "stop.fill" : "mic.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
        .disabled(viewModel.isButtonDisabled)
        .scaleEffect(viewModel.isRunning ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isRunning)
    }
}

#Preview {
    ExerciseView()
}
