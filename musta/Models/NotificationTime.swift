import Foundation

struct NotificationTime: Codable, Identifiable {
    let id: Int
    var time: String
    var isEnabled: Bool
    var isCustom: Bool
    var notificationID: String?
}
