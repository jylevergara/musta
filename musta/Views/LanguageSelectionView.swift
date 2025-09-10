import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
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
                } else {
                    List(languageManager.languages) { language in
                        LanguageRowView(
                            language: language,
                            isSelected: languageManager.currentLanguage?.id == language.id
                        ) {
                            languageManager.setLanguage(language)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Languages")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct LanguageRowView: View {
    let language: Language
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(language.flag)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(language.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(language.nativeName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(LanguageManager())
}
