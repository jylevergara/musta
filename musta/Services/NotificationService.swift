import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleNotification(for time: String, languageId: String, notificationID: String) {
        let content = UNMutableNotificationContent()
        content.title = "Time to learn a new phrase 🤓"
        
        // Get random phrase from the language
        if let language = getLanguageById(languageId),
           let randomPhrase = language.phrases.randomElement() {
            content.body = "\(randomPhrase.phrase) - \(randomPhrase.translation)"
        } else {
            content.body = "Time to practice your language skills!"
        }
        
        content.sound = .default
        content.badge = 1
        
        // Parse time string (format: "HH:mm")
        let timeComponents = time.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1]) else {
            print("Invalid time format: \(time)")
            return
        }
        
        // Create date components with current calendar
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        
        // Create the trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // Add the notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Successfully scheduled notification for \(time) with ID: \(notificationID)")
                
                // Debug: Print pending notifications
                UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                    print("Total pending notifications: \(requests.count)")
                    for request in requests {
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                            print("Notification ID: \(request.identifier), Time: \(trigger.dateComponents)")
                        }
                    }
                }
            }
        }
    }
    
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func getLanguageById(_ id: String) -> Language? {
        return DataService.shared.loadLanguages().first { $0.id == id }
    }
}
