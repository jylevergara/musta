import Foundation

struct Language: Codable, Identifiable {
    let id: String
    let name: String
    let nativeName: String
    let flag: String
    let phrases: [Phrase]
}

struct Phrase: Codable, Identifiable {
    let id = UUID()
    let phrase: String
    let translation: String
}
