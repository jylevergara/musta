import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var currentLanguage: Language?
    @Published var languages: [Language] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let selectedLanguageKey = "selectedLanguageId"
    
    init() {
        loadLanguages()
    }
    
    func loadLanguages() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            let loadedLanguages = DataService.shared.loadLanguages()
            
            DispatchQueue.main.async {
                self.languages = loadedLanguages
                self.isLoading = false
                
                if loadedLanguages.isEmpty {
                    self.errorMessage = "Failed to load languages"
                } else {
                    // Load the selected language after languages are loaded
                    self.loadSelectedLanguage()
                }
            }
        }
    }
    
    func setLanguage(_ language: Language) {
        let previousLanguage = currentLanguage
        currentLanguage = language
        userDefaults.set(language.id, forKey: selectedLanguageKey)
        
        // Update notifications for the new language
        NotificationManager.shared.updateNotificationsForLanguage(language.id)
        
        print("Language changed from '\(previousLanguage?.name ?? "none")' to '\(language.name)' - notifications updated")
    }
    
    private func loadSelectedLanguage() {
        if let selectedLanguageId = userDefaults.string(forKey: selectedLanguageKey) {
            currentLanguage = languages.first { $0.id == selectedLanguageId }
        } else {
            // Default to first language if none selected
            if let firstLanguage = languages.first {
                setLanguage(firstLanguage)
            }
        }
    }
    
    func refreshData() {
        loadLanguages()
    }
}
