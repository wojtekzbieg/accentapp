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
    
    // MARK: - Tongue Twisters
    static let tongueTwisters: [String] = [
        "She sells seashells by the seashore.",
        "Peter Piper picked a peck of pickled peppers.",
        "How much wood would a woodchuck chuck if a woodchuck could chuck wood?",
        "Red leather, yellow leather, red leather, yellow leather.",
        "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. Fuzzy Wuzzy wasn't very fuzzy, was he?",
        "I scream, you scream, we all scream for ice cream.",
        "A proper copper coffee pot.",
        "Six slippery snails slid slowly seaward.",
        "The great Greek grape growers grow great Greek grapes.",
        "Toy boat, toy boat, toy boat.",
        "Unique New York, unique New York, unique New York.",
        "Red lorry, yellow lorry, red lorry, yellow lorry.",
        "Betty Botter bought some butter, but she said the butter's bitter.",
        "If I put it in my batter, it will make my batter bitter.",
        "So she bought some better butter, better than the bitter butter.",
        "A big black bug bit a big black bear, made the big black bear bleed blood.",
        "I wish to wish the wish you wish to wish, but if you wish the wish the witch wishes, I won't wish the wish you wish to wish.",
        "The thirty-three thieves thought that they thrilled the throne throughout Thursday.",
        "Can you can a can as a canner can can a can?",
        "I saw a kitten eating chicken in the kitchen."
    ]
    
    static let ipaSymbols: [IPASymbol] = [
        // Vowels
        IPASymbol(symbol: "iː", description: "Długie i", example: "see", pronunciation: "see", phoneticTranscription: "[siː]"),
        IPASymbol(symbol: "ɪ", description: "Krótkie i", example: "sit", pronunciation: "sit", phoneticTranscription: "[sɪt]"),
        IPASymbol(symbol: "e", description: "E jak w 'met'", example: "met", pronunciation: "met", phoneticTranscription: "[met]"),
        IPASymbol(symbol: "æ", description: "A jak w 'cat'", example: "cat", pronunciation: "cat", phoneticTranscription: "[kæt]"),
        IPASymbol(symbol: "ɑː", description: "Długie a", example: "car", pronunciation: "car", phoneticTranscription: "[kɑː]"),
        IPASymbol(symbol: "ɒ", description: "Krótkie o", example: "hot", pronunciation: "hot", phoneticTranscription: "[hɒt]"),
        IPASymbol(symbol: "ɔː", description: "Długie o", example: "saw", pronunciation: "saw", phoneticTranscription: "[sɔː]"),
        IPASymbol(symbol: "ʊ", description: "Krótkie u", example: "put", pronunciation: "put", phoneticTranscription: "[pʊt]"),
        IPASymbol(symbol: "uː", description: "Długie u", example: "blue", pronunciation: "blue", phoneticTranscription: "[bluː]"),
        IPASymbol(symbol: "ʌ", description: "A jak w 'cup'", example: "cup", pronunciation: "cup", phoneticTranscription: "[kʌp]"),
        IPASymbol(symbol: "ɜː", description: "E jak w 'bird'", example: "bird", pronunciation: "bird", phoneticTranscription: "[bɜːd]"),
        IPASymbol(symbol: "ə", description: "Schwa", example: "about", pronunciation: "about", phoneticTranscription: "[əˈbaʊt]"),
        
        // Consonants
        IPASymbol(symbol: "p", description: "P jak w 'pen'", example: "pen", pronunciation: "pen", phoneticTranscription: "[pen]"),
        IPASymbol(symbol: "b", description: "B jak w 'big'", example: "big", pronunciation: "big", phoneticTranscription: "[bɪɡ]"),
        IPASymbol(symbol: "t", description: "T jak w 'top'", example: "top", pronunciation: "top", phoneticTranscription: "[tɒp]"),
        IPASymbol(symbol: "d", description: "D jak w 'dog'", example: "dog", pronunciation: "dog", phoneticTranscription: "[dɒɡ]"),
        IPASymbol(symbol: "k", description: "K jak w 'cat'", example: "cat", pronunciation: "cat", phoneticTranscription: "[kæt]"),
        IPASymbol(symbol: "ɡ", description: "G jak w 'go'", example: "go", pronunciation: "go", phoneticTranscription: "[ɡəʊ]"),
        IPASymbol(symbol: "f", description: "F jak w 'fish'", example: "fish", pronunciation: "fish", phoneticTranscription: "[fɪʃ]"),
        IPASymbol(symbol: "v", description: "V jak w 'very'", example: "very", pronunciation: "very", phoneticTranscription: "[ˈveri]"),
        IPASymbol(symbol: "θ", description: "TH jak w 'think'", example: "think", pronunciation: "think", phoneticTranscription: "[θɪŋk]"),
        IPASymbol(symbol: "ð", description: "TH jak w 'this'", example: "this", pronunciation: "this", phoneticTranscription: "[ðɪs]"),
        IPASymbol(symbol: "s", description: "S jak w 'sun'", example: "sun", pronunciation: "sun", phoneticTranscription: "[sʌn]"),
        IPASymbol(symbol: "z", description: "Z jak w 'zoo'", example: "zoo", pronunciation: "zoo", phoneticTranscription: "[zuː]"),
        IPASymbol(symbol: "ʃ", description: "SH jak w 'she'", example: "she", pronunciation: "she", phoneticTranscription: "[ʃiː]"),
        IPASymbol(symbol: "ʒ", description: "ZH jak w 'pleasure'", example: "pleasure", pronunciation: "pleasure", phoneticTranscription: "[ˈpleʒə]"),
        IPASymbol(symbol: "h", description: "H jak w 'hat'", example: "hat", pronunciation: "hat", phoneticTranscription: "[hæt]"),
        IPASymbol(symbol: "m", description: "M jak w 'man'", example: "man", pronunciation: "man", phoneticTranscription: "[mæn]"),
        IPASymbol(symbol: "n", description: "N jak w 'no'", example: "no", pronunciation: "no", phoneticTranscription: "[nəʊ]"),
        IPASymbol(symbol: "ŋ", description: "NG jak w 'sing'", example: "sing", pronunciation: "sing", phoneticTranscription: "[sɪŋ]"),
        IPASymbol(symbol: "l", description: "L jak w 'leg'", example: "leg", pronunciation: "leg", phoneticTranscription: "[leɡ]"),
        IPASymbol(symbol: "r", description: "R jak w 'red'", example: "red", pronunciation: "red", phoneticTranscription: "[red]"),
        IPASymbol(symbol: "w", description: "W jak w 'wet'", example: "wet", pronunciation: "wet", phoneticTranscription: "[wet]"),
        IPASymbol(symbol: "j", description: "Y jak w 'yes'", example: "yes", pronunciation: "yes", phoneticTranscription: "[jes]")
    ]
}
