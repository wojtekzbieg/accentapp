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
        case .ranking:
            Text("Ranking")
        case .profile:
            Text("Profil")
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
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ostatnia sesja")
                                .font(.headline)
                            HStack {
                                Label("Wymowa: \(session.pronunciationScore)%", systemImage: "checkmark.seal.fill")
                                Spacer()
                                Label("Akcent: \(session.accentScore)%", systemImage: "dial.medium.fill")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    
                    Spacer(minLength: 8)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Say it right!")
        }
    }
}

struct FeatureButton: View {
    let title: String
    let icon: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(tint)
                    .clipShape(Circle())

                Text(title)
                    .font(.subheadline).bold()
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, minHeight: 110)
            .padding(12)
            .background(.background)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.quaternary, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
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

#Preview("Full App") {
    ContentView()
}

