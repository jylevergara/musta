import Foundation

struct Language: Codable, Identifiable {
    let id: String
    let name: String
    let nativeName: String
    let flag: String
    let phrases: [Phrase]
}

struct Phrase: Codable, Identifiable {
    let id: String
    let phrase: String
    let translation: String
    
    init(phrase: String, translation: String) {
        self.id = UUID().uuidString
        self.phrase = phrase
        self.translation = translation
    }
    
    // Custom decoder to handle the UUID generation
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.phrase = try container.decode(String.self, forKey: .phrase)
        self.translation = try container.decode(String.self, forKey: .translation)
        self.id = UUID().uuidString
    }
    
    private enum CodingKeys: String, CodingKey {
        case phrase, translation
    }
}
