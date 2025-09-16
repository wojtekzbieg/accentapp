import Foundation

// MARK: - Models

struct User {
    let id: UUID
    let name: String
    let email: String?
    let joinDate: Date
    
    init(name: String, email: String? = nil) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.joinDate = Date()
    }
}

struct Session {
    let id: UUID
    let date: Date
    let pronunciationScore: Int
    let accentScore: Int
    let duration: TimeInterval
    
    init(pronunciationScore: Int, accentScore: Int, duration: TimeInterval) {
        self.id = UUID()
        self.date = Date()
        self.pronunciationScore = pronunciationScore
        self.accentScore = accentScore
        self.duration = duration
    }
}

struct Feature {
    let id: UUID
    let title: String
    let icon: String
    let tint: String
    let action: FeatureAction
    
    init(title: String, icon: String, tint: String, action: FeatureAction) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.tint = tint
        self.action = action
    }
}

enum FeatureAction {
    case exercises
    case progress
    case listenAI
    case challenges
    case profile
    case ranking
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case exercises = "Ćwiczenia"
    case ranking = "Ranking"
    case profile = "Profil"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .exercises: return "book.fill"
        case .ranking: return "crown.fill"
        case .profile: return "person.fill"
        }
    }
}
