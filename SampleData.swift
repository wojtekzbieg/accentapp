import Foundation

// MARK: - Sample Data for Previews

struct SampleData {
    static let samplePronunciationScores = PronunciationScores(
        overallScore: 89.0,
        accuracyScore: 92.0,
        fluencyScore: 85.0,
        completenessScore: 95.0,
        prosodyScore: 88.0,
        words: sampleWords
    )
    
    static let sampleWords: [WordResult] = [
        WordResult(
            word: "They",
            accuracyScore: 96.0,
            syllables: [
                SyllableResult(syllable: "TH", grapheme: "TH", accuracyScore: 93.0),
                SyllableResult(syllable: "EY", grapheme: "EY", accuracyScore: 99.0)
            ]
        ),
        WordResult(
            word: "were",
            accuracyScore: 94.0,
            syllables: [
                SyllableResult(syllable: "W", grapheme: "W", accuracyScore: 99.0),
                SyllableResult(syllable: "ER", grapheme: "ER", accuracyScore: 89.0)
            ]
        ),
        WordResult(
            word: "looking",
            accuracyScore: 89.0,
            syllables: [
                SyllableResult(syllable: "L", grapheme: "L", accuracyScore: 94.0),
                SyllableResult(syllable: "U", grapheme: "U", accuracyScore: 96.0),
                SyllableResult(syllable: "K", grapheme: "K", accuracyScore: 100.0),
                SyllableResult(syllable: "IH", grapheme: "IH", accuracyScore: 91.0),
                SyllableResult(syllable: "NG", grapheme: "NG", accuracyScore: 100.0)
            ]
        ),
        WordResult(
            word: "for",
            accuracyScore: 95.0,
            syllables: [
                SyllableResult(syllable: "F", grapheme: "F", accuracyScore: 99.0),
                SyllableResult(syllable: "OR", grapheme: "OR", accuracyScore: 92.0)
            ]
        ),
        WordResult(
            word: "a",
            accuracyScore: 90.0,
            syllables: [
                SyllableResult(syllable: "R", grapheme: "R", accuracyScore: 90.0),
                SyllableResult(syllable: "uh", grapheme: "uh", accuracyScore: 100.0)
            ]
        ),
        WordResult(
            word: "good",
            accuracyScore: 96.0,
            syllables: [
                SyllableResult(syllable: "G", grapheme: "G", accuracyScore: 100.0),
                SyllableResult(syllable: "U", grapheme: "U", accuracyScore: 89.0),
                SyllableResult(syllable: "D", grapheme: "D", accuracyScore: 100.0)
            ]
        ),
        WordResult(
            word: "book",
            accuracyScore: 83.0,
            syllables: [
                SyllableResult(syllable: "B", grapheme: "B", accuracyScore: 100.0),
                SyllableResult(syllable: "U", grapheme: "U", accuracyScore: 49.0),
                SyllableResult(syllable: "K", grapheme: "K", accuracyScore: 100.0)
            ]
        )
    ]
    
    static let sampleText = "they were looking for a good book"
    static let sampleWordsArray = sampleText.components(separatedBy: " ")
}
