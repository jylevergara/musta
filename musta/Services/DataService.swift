import Foundation

struct LanguageData: Codable {
    let languages: [Language]
}

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    func loadLanguages() -> [Language] {
        guard let url = Bundle.main.url(forResource: "languageData", withExtension: "json") else {
            print("Error: Could not find languageData.json in bundle")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let languageData = try JSONDecoder().decode(LanguageData.self, from: data)
            return languageData.languages
        } catch {
            print("Error decoding language data: \(error)")
            return []
        }
    }
}
