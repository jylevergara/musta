import SwiftUI

struct HomeView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            Group {
                if languageManager.isLoading {
                    ProgressView("Loading languages...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = languageManager.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .font(.headline)
                        Button("Retry") {
                            languageManager.refreshData()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let currentLanguage = languageManager.currentLanguage {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            // Language Header
                            VStack(spacing: 8) {
                                Text(currentLanguage.flag)
                                    .font(.system(size: 60))
                                
                                Text(currentLanguage.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Text(currentLanguage.nativeName)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Text("Learn this language or forever be trapped in tourist restaurants with pictures on the menu.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 8)
                            }
                            .padding(.vertical, 20)
                            
                            // Flashcards
                            ForEach(currentLanguage.phrases) { phrase in
                                FlashCard(phrase: phrase.phrase, translation: phrase.translation)
                            }
                        }
                    }
                    .refreshable {
                        await refreshData()
                    }
                } else {
                    VStack {
                        Image(systemName: "globe")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        Text("Select a language to start learning")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Musta")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func refreshData() async {
        isRefreshing = true
        languageManager.refreshData()
        isRefreshing = false
    }
}

#Preview {
    HomeView()
        .environmentObject(LanguageManager())
}
