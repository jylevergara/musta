import Foundation
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notificationTimes: [NotificationTime] = []
    @Published var isPermissionGranted = false
    
    private let userDefaults = UserDefaults.standard
    private let notificationTimesKey = "notificationTimes"
    private let permissionKey = "notificationPermission"
    
    private init() {
        loadNotificationTimes()
        checkPermissionStatus()
        setupDefaultTimes()
    }
    
    func requestPermission() {
        NotificationService.shared.requestPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.isPermissionGranted = granted
                self?.userDefaults.set(granted, forKey: self?.permissionKey ?? "")
                
                if granted {
                    self?.scheduleAllNotifications()
                }
            }
        }
    }
    
    func addNotificationTime(_ time: String) {
        let newId = (notificationTimes.map { $0.id }.max() ?? 0) + 1
        let notificationID = "musta_notification_\(newId)"
        
        let newTime = NotificationTime(
            id: newId,
            time: time,
            isEnabled: true,
            isCustom: true,
            notificationID: notificationID
        )
        
        notificationTimes.append(newTime)
        saveNotificationTimes()
        
        if isPermissionGranted {
            scheduleNotification(for: newTime)
        }
    }
    
    func toggleNotification(_ notificationTime: NotificationTime) {
        if let index = notificationTimes.firstIndex(where: { $0.id == notificationTime.id }) {
            notificationTimes[index].isEnabled.toggle()
            saveNotificationTimes()
            
            if notificationTimes[index].isEnabled {
                scheduleNotification(for: notificationTimes[index])
            } else {
                if let notificationID = notificationTimes[index].notificationID {
                    NotificationService.shared.cancelNotification(id: notificationID)
                }
            }
        }
    }
    
    func deleteNotificationTime(_ notificationTime: NotificationTime) {
        if let notificationID = notificationTime.notificationID {
            NotificationService.shared.cancelNotification(id: notificationID)
        }
        
        notificationTimes.removeAll { $0.id == notificationTime.id }
        saveNotificationTimes()
    }
    
    func updateNotificationTime(_ notificationTime: NotificationTime, newTime: String) {
        if let index = notificationTimes.firstIndex(where: { $0.id == notificationTime.id }) {
            // Cancel old notification
            if let oldNotificationID = notificationTimes[index].notificationID {
                NotificationService.shared.cancelNotification(id: oldNotificationID)
            }
            
            // Update time and create new notification ID
            let newNotificationID = "musta_notification_\(notificationTime.id)_\(Date().timeIntervalSince1970)"
            notificationTimes[index].time = newTime
            notificationTimes[index].notificationID = newNotificationID
            
            saveNotificationTimes()
            
            // Schedule new notification if enabled
            if notificationTimes[index].isEnabled && isPermissionGranted {
                scheduleNotification(for: notificationTimes[index])
            }
        }
    }
    
    func updateNotificationsForLanguage(_ languageId: String) {
        guard isPermissionGranted else { return }
        
        // Cancel all existing notifications
        NotificationService.shared.cancelAllNotifications()
        
        // Reschedule all enabled notifications with new language
        for notificationTime in notificationTimes where notificationTime.isEnabled {
            scheduleNotification(for: notificationTime, languageId: languageId)
        }
    }
    
    private func scheduleNotification(for notificationTime: NotificationTime, languageId: String? = nil) {
        guard let notificationID = notificationTime.notificationID else { return }
        
        let currentLanguageId = languageId ?? "fil"
        NotificationService.shared.scheduleNotification(
            for: notificationTime.time,
            languageId: currentLanguageId,
            notificationID: notificationID
        )
    }
    
    private func scheduleAllNotifications() {
        for notificationTime in notificationTimes where notificationTime.isEnabled {
            scheduleNotification(for: notificationTime)
        }
    }
    
    private func setupDefaultTimes() {
        if notificationTimes.isEmpty {
            let defaultTimes = [
                NotificationTime(id: 1, time: "08:00", isEnabled: true, isCustom: false, notificationID: "musta_notification_1"),
                NotificationTime(id: 2, time: "20:00", isEnabled: true, isCustom: false, notificationID: "musta_notification_2")
            ]
            
            notificationTimes = defaultTimes
            saveNotificationTimes()
        }
    }
    
    private func loadNotificationTimes() {
        if let data = userDefaults.data(forKey: notificationTimesKey),
           let times = try? JSONDecoder().decode([NotificationTime].self, from: data) {
            notificationTimes = times
        }
        
        isPermissionGranted = userDefaults.bool(forKey: permissionKey)
    }
    
    private func saveNotificationTimes() {
        if let data = try? JSONEncoder().encode(notificationTimes) {
            userDefaults.set(data, forKey: notificationTimesKey)
        }
    }
    
    private func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isPermissionGranted = settings.authorizationStatus == .authorized
                self.userDefaults.set(self.isPermissionGranted, forKey: self.permissionKey)
            }
        }
    }
    
    // Helper function to format time for display in 12-hour AM/PM format
    static func formatTimeForDisplay(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: timeString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "hh:mm a"
            displayFormatter.locale = Locale(identifier: "en_US")
            return displayFormatter.string(from: date)
        }
        
        return timeString
    }
}
