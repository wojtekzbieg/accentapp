import Foundation
import SwiftUI

// MARK: - ViewModels

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isOnboardingComplete = false
    
    func startApp() {
        isOnboardingComplete = true
    }
    
    func login() {
        // TODO: Implement login logic
        startApp()
    }
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var user: User
    @Published var lastSession: Session?
    @Published var features: [Feature] = []
    
    init(user: User = User(name: "Adam")) {
        self.user = user
        self.lastSession = Session(pronunciationScore: 82, accentScore: 90, duration: 300)
        setupFeatures()
    }
    
    private func setupFeatures() {
        features = [
            Feature(title: "Ćwiczenia", icon: "headphones", tint: "blue", action: .exercises),
            Feature(title: "Postępy", icon: "chart.bar", tint: "purple", action: .progress),
            Feature(title: "Słuchaj AI", icon: "speaker.wave.2.fill", tint: "pink", action: .listenAI),
            Feature(title: "Wyzwania", icon: "flame.fill", tint: "orange", action: .challenges)
        ]
    }
    
    func handleFeatureAction(_ action: FeatureAction) {
        switch action {
        case .exercises:
            // TODO: Navigate to exercises
            break
        case .progress:
            // TODO: Navigate to progress
            break
        case .listenAI:
            // TODO: Start AI listening
            break
        case .challenges:
            // TODO: Navigate to challenges
            break
        case .profile:
            // TODO: Navigate to profile
            break
        case .ranking:
            // TODO: Navigate to ranking
            break
        }
    }
    
    func getColorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        default: return .blue
        }
    }
}

@MainActor
class ExerciseViewModel: ObservableObject {
    @Published var referenceText: String = ""
    @Published var isRunning: Bool = false
    @Published var scores: PronunciationScores?
    @Published var errorMessage: String?
    @Published var selectedLanguage: String = "en-US"
    @Published var isRecording: Bool = false
    @Published var recordingDuration: TimeInterval = 0
    @Published var showResults: Bool = false
    @Published var currentWordIndex: Int = 0
    @Published var showDetailedFeedback: Bool = false
    
    private let speechService = SpeechService(
        subscriptionKey: "subcriptionKey",
        serviceRegion: "eastus"
    )
    
    private var recordingTimer: Timer?
    
    let availableLanguages = [
        ("en-US", "English (US)", "🇺🇸"),
        ("en-GB", "English (UK)", "🇬🇧"),
        ("es-ES", "Spanish (Spain)", "🇪🇸"),
        ("es-MX", "Spanish (Mexico)", "🇲🇽"),
        ("fr-FR", "French (France)", "🇫🇷"),
        ("de-DE", "German (Germany)", "🇩🇪"),
        ("it-IT", "Italian (Italy)", "🇮🇹"),
        ("pt-BR", "Portuguese (Brazil)", "🇧🇷"),
        ("pt-PT", "Portuguese (Portugal)", "🇵🇹"),
        ("ru-RU", "Russian (Russia)", "🇷🇺"),
        ("ja-JP", "Japanese (Japan)", "🇯🇵"),
        ("ko-KR", "Korean (Korea)", "🇰🇷"),
        ("zh-CN", "Chinese (Mandarin)", "🇨🇳"),
        ("ar-SA", "Arabic (Saudi Arabia)", "🇸🇦"),
        ("hi-IN", "Hindi (India)", "🇮🇳"),
        ("pl-PL", "Polish (Poland)", "🇵🇱")
    ]
    
    init() {
        referenceText = ""
    }
    
    var selectedLanguageDisplayName: String {
        if let language = availableLanguages.first(where: { $0.0 == selectedLanguage }) {
            return "\(language.2) \(language.1)"
        }
        return "🇺🇸 English (US)"
    }
    
    var defaultTextForLanguage: String {
        switch selectedLanguage {
        case "en-US", "en-GB":
            return "The quick brown fox jumps over the lazy dog."
        case "es-ES", "es-MX":
            return "El zorro marrón rápido salta sobre el perro perezoso."
        case "fr-FR":
            return "Le renard brun rapide saute par-dessus le chien paresseux."
        case "de-DE":
            return "Der schnelle braune Fuchs springt über den faulen Hund."
        case "it-IT":
            return "La volpe marrone veloce salta sopra il cane pigro."
        case "pt-BR", "pt-PT":
            return "A raposa marrom rápida pula sobre o cão preguiçoso."
        case "ru-RU":
            return "Быстрая коричневая лиса перепрыгивает через ленивую собаку."
        case "ja-JP":
            return "素早い茶色の狐が怠惰な犬を飛び越える。"
        case "ko-KR":
            return "빠른 갈색 여우가 게으른 개를 뛰어넘는다."
        case "zh-CN":
            return "敏捷的棕色狐狸跳过懒惰的狗。"
        case "ar-SA":
            return "الثعلب البني السريع يقفز فوق الكلب الكسول."
        case "hi-IN":
            return "तेज़ भूरी लोमड़ी आलसी कुत्ते के ऊपर कूदती है।"
        case "pl-PL":
            return "Szybki brązowy lis przeskakuje nad leniwym psem."
        default:
            return "The quick brown fox jumps over the lazy dog."
        }
    }
    
    var buttonTitle: String {
        if isRunning {
            return "Słucham..."
        } else if scores != nil {
            return "Spróbuj ponownie"
        } else {
            return "Rozpocznij ocenę"
        }
    }
    
    var buttonBackgroundColor: Color {
        if isRunning {
            return .gray
        } else if scores != nil {
            return .orange
        } else {
            return .blue
        }
    }
    
    var isButtonDisabled: Bool {
        isRunning || referenceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func selectLanguage(_ language: String) {
        selectedLanguage = language
        referenceText = defaultTextForLanguage
    }
    
    func startAssessment() {
        isRunning = true
        errorMessage = nil
        scores = nil
        showResults = false
        isRecording = true
        recordingDuration = 0
        
        startRecordingTimer()
        
        speechService.requestMicrophonePermission { granted in
            guard granted else {
                self.isRunning = false
                self.isRecording = false
                self.errorMessage = "Brak uprawnień do mikrofonu. Włącz w Ustawieniach."
                self.stopRecordingTimer()
                return
            }
            
            self.speechService.startPronunciationAssessment(referenceText: self.referenceText, language: self.selectedLanguage) { result in
                self.isRunning = false
                self.isRecording = false
                self.stopRecordingTimer()
                
                switch result {
                case .success(let pronunciationScores):
                    self.scores = pronunciationScores
                    self.showResults = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func resetAssessment() {
        scores = nil
        errorMessage = nil
        showResults = false
        isRecording = false
        recordingDuration = 0
        currentWordIndex = 0
        showDetailedFeedback = false
        stopRecordingTimer()
    }
    
    func selectWord(at index: Int) {
        currentWordIndex = index
        showDetailedFeedback = true
    }
    
    func nextWord() {
        let words = referenceText.components(separatedBy: " ")
        if currentWordIndex < words.count - 1 {
            currentWordIndex += 1
        } else {
            // Loop to first word when at last word
            currentWordIndex = 0
        }
    }
    
    func previousWord() {
        let words = referenceText.components(separatedBy: " ")
        if currentWordIndex > 0 {
            currentWordIndex -= 1
        } else {
            // Loop to last word when at first word
            currentWordIndex = words.count - 1
        }
    }
    
    var words: [String] {
        referenceText.components(separatedBy: " ")
    }
    
    var currentWord: String {
        guard currentWordIndex < words.count else { return "" }
        return words[currentWordIndex]
    }
    
    var currentWordScores: [SyllableResult]? {
        guard let scores = scores,
              let wordResults = scores.words,
              currentWordIndex < wordResults.count else { return nil }
        return wordResults[currentWordIndex].syllables
    }
    
    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                self.recordingDuration += 0.1
            }
        }
    }
    
    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }
    
    deinit {
        Task { @MainActor in
            stopRecordingTimer()
        }
    }
}

@MainActor
class MainViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .home
    @Published var isOnboardingComplete = false
    
    private let onboardingViewModel = OnboardingViewModel()
    private let homeViewModel = HomeViewModel()
    
    init() {
        // Check if user has completed onboarding
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "isOnboardingComplete")
    }
    
    func completeOnboarding() {
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")
    }
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
}
