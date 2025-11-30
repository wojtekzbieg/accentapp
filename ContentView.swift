import SwiftUI

// MARK: - Onboarding
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Image(systemName: "waveform.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundStyle(.white)
                .shadow(radius: 10)
            
            Text("Speak with Confidence")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text("Ćwicz akcent i wymowę z pomocą AI – krok po kroku.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 16) {
                Button(action: {
                    viewModel.startApp()
                    onStart()
                }) {
                    Text("Rozpocznij")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundColor(.purple)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .accessibilityIdentifier("startButton")

                Button(action: {
                    viewModel.login()
                    onStart()
                }) {
                    Text("Zaloguj się") // placeholder – podłączysz później
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                .accessibilityIdentifier("loginButton")
            }
            .padding(.horizontal, 30)

            Spacer(minLength: 24)
        }
        .background(
            LinearGradient(colors: [.purple, .blue],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
        )
    }
}

// MARK: - Main (Home only for now)
struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                tabView(for: tab)
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
    }
    
    @ViewBuilder
    private func tabView(for tab: TabItem) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .exercises:
            ExerciseView()
        case .learning:
            LearningView()
        case .ranking:
            RankingView()
        case .profile:
            ProfileView()
        }
    }
}


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Witaj, \(viewModel.user.name) 👋")
                        .font(.title2).bold()
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 14) {
                        ForEach(viewModel.features, id: \.id) { feature in
                            FeatureButton(
                                title: feature.title,
                                icon: feature.icon,
                                tint: viewModel.getColorFromString(feature.tint)
                            ) {
                                viewModel.handleFeatureAction(feature.action)
                            }
                        }
                    }
                    
                    if let session = viewModel.lastSession {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ostatnia sesja")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            
                            HStack {
                                Label("Wymowa: \(session.pronunciationScore)%", systemImage: "checkmark.seal.fill")
                                Spacer()
                                Label("Akcent: \(session.accentScore)%", systemImage: "dial.medium.fill")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                ZStack {
                                    // Liquid Glass background
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.7)
                                    
                                    // Subtle gradient overlay
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    .white.opacity(0.08),
                                                    .clear,
                                                    .white.opacity(0.03)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                .white.opacity(0.4),
                                                .white.opacity(0.05),
                                                .clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
                            .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
                        }
                    }
                    
                    Spacer(minLength: 8)
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Say it right!")
        }
    }
}

struct FeatureButton: View {
    let title: String
    let icon: String
    let tint: Color
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(18)
                    .background(
                        Circle()
                            .fill(tint)
                        // TA LINIA NIŻEJ ROBI FAJNY EFEKT
                            .shadow(color: tint.opacity(0.3), radius: 8, x: 0, y: 4)
                    )

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(16)
            .background(
                ZStack {
                    // Liquid Glass background
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.8)
                    
                    // Subtle gradient overlay
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.1),
                                    .clear,
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.6),
                                .white.opacity(0.1),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}


// MARK: - Main ContentView
struct ContentView: View {
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        if mainViewModel.isOnboardingComplete {
            MainView()
        } else {
            OnboardingView {
                mainViewModel.completeOnboarding()
            }
        }
    }
}

// MARK: - Previews
#Preview("Onboarding") {
    OnboardingView { }
}

#Preview("Home") {
    MainView()
}

struct RankingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Ranking")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Wkrótce...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Ranking")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Wkrótce...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview("Full App") {
    ContentView()
}

