import Foundation
import AVFoundation
import MicrosoftCognitiveServicesSpeech

struct PronunciationScores {
    let overallScore: Double
    let accuracyScore: Double
    let fluencyScore: Double
    let completenessScore: Double
    let prosodyScore: Double?
    let words: [WordResult]?
}

struct SyllableResult {
    let syllable: String?
    let grapheme: String?
    let accuracyScore: Double
}

struct WordResult {
    let word: String?
    let accuracyScore: Double
    let syllables: [SyllableResult]
}

final class SpeechService: NSObject {
    private var speechRecognizer: SPXSpeechRecognizer?
    private var speechConfig: SPXSpeechConfiguration?

    private let subscriptionKey: String
    private let serviceRegion: String

    init(subscriptionKey: String, serviceRegion: String) {
        self.subscriptionKey = subscriptionKey
        self.serviceRegion = serviceRegion
        super.init()
    }

    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        @unknown default:
            completion(false)
        }
    }

    func startPronunciationAssessment(
        referenceText: String,
        language: String = "en-US",
        completion: @escaping (Result<PronunciationScores, Error>) -> Void
    ) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        do {
            let config = try SPXSpeechConfiguration(subscription: subscriptionKey, region: serviceRegion)
            config.speechRecognitionLanguage = language
            self.speechConfig = config

            let audioConfig = SPXAudioConfiguration()
            let recognizer = try SPXSpeechRecognizer(speechConfiguration: config, audioConfiguration: audioConfig)

            let paConfig = try SPXPronunciationAssessmentConfiguration(
                referenceText,
                gradingSystem: .hundredMark,
                granularity: .phoneme,
                enableMiscue: true
            )
            
            // Use IPA for phoneme representation in timing results
            paConfig.phonemeAlphabet = "IPA"
            paConfig.enableProsodyAssessment()
            
            try paConfig.apply(to: recognizer)

            self.speechRecognizer = recognizer

            do {
                try recognizer.recognizeOnceAsync { result in
                    if result.reason == .canceled {
                        do {
                            let cancellation = try SPXCancellationDetails(fromCanceledRecognitionResult: result)
                            let code = cancellation.errorCode
                            let description = cancellation.errorDetails ?? "Recognition canceled"
                            let err = NSError(domain: "SpeechService", code: Int(code.rawValue), userInfo: [NSLocalizedDescriptionKey: description])
                            DispatchQueue.main.async { completion(.failure(err)) }
                        } catch {
                            DispatchQueue.main.async { completion(.failure(error)) }
                        }
                        return
                    }

                    if let paResult = SPXPronunciationAssessmentResult(result) {
                        let prosody: Double? = paResult.prosodyScore >= 0 ? paResult.prosodyScore : nil

                        var wordResults: [WordResult] = []
                        if let words = paResult.words {
                            for w in words {
                                let syllablesArray = w.syllables ?? []
                                let syllables: [SyllableResult] = syllablesArray.map { s in
                                    SyllableResult(
                                        syllable: s.syllable,
                                        grapheme: s.grapheme,
                                        accuracyScore: s.accuracyScore
                                    )
                                }
                                wordResults.append(
                                    WordResult(
                                        word: w.word,
                                        accuracyScore: w.accuracyScore,
                                        syllables: syllables
                                    )
                                )
                            }
                        }

                        let scores = PronunciationScores(
                            overallScore: paResult.pronunciationScore,
                            accuracyScore: paResult.accuracyScore,
                            fluencyScore: paResult.fluencyScore,
                            completenessScore: paResult.completenessScore,
                            prosodyScore: prosody,
                            words: wordResults.isEmpty ? nil : wordResults
                        )
                        DispatchQueue.main.async { completion(.success(scores)) }
                    } else {
                        let err = NSError(domain: "SpeechService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No pronunciation result."])
                        DispatchQueue.main.async { completion(.failure(err)) }
                    }
                }
            } catch {
                completion(.failure(error))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func stop() {
        if let recognizer = speechRecognizer {
            try? recognizer.stopContinuousRecognition()
        }
        speechRecognizer = nil
    }
}


