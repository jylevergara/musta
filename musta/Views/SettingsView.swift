import SwiftUI

struct SettingsView: View {
    @StateObject private var notificationManager = NotificationManager.shared
    @State private var showingAddTimeSheet = false
    @State private var showingPermissionAlert = false
    @State private var newTime = Date()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications")) {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(.blue)
                        Text("Daily Reminders")
                        Spacer()
                        if !notificationManager.isPermissionGranted {
                            Button("Enable") {
                                requestPermission()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    if !notificationManager.isPermissionGranted {
                        Text("Enable notifications to receive daily language learning reminders")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if notificationManager.isPermissionGranted {
                    Section(header: Text("Notification Times")) {
                        ForEach(notificationManager.notificationTimes) { notificationTime in
                            NotificationTimeRowView(
                                notificationTime: notificationTime,
                                onToggle: {
                                    notificationManager.toggleNotification(notificationTime)
                                },
                                onDelete: {
                                    notificationManager.deleteNotificationTime(notificationTime)
                                },
                                onUpdate: { newTime in
                                    notificationManager.updateNotificationTime(notificationTime, newTime: newTime)
                                }
                            )
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let notificationTime = notificationManager.notificationTimes[index]
                                notificationManager.deleteNotificationTime(notificationTime)
                            }
                        }
                        
                        Button(action: {
                            showingAddTimeSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                Text("Add Custom Time")
                                    .foregroundColor(.green)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.red)
                        Text("Made with ❤️ for language learners")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddTimeSheet) {
                AddNotificationTimeView(
                    isPresented: $showingAddTimeSheet,
                    onAdd: { timeString in
                        notificationManager.addNotificationTime(timeString)
                    }
                )
            }
            .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable notifications in Settings to receive daily language learning reminders.")
            }
        }
    }
    
    private func requestPermission() {
        notificationManager.requestPermission()
    }
}

struct NotificationTimeRowView: View {
    let notificationTime: NotificationTime
    let onToggle: () -> Void
    let onDelete: () -> Void
    let onUpdate: (String) -> Void
    
    @State private var isEditing = false
    @State private var editedTime = Date()
    
    var body: some View {
        HStack {
            // Time and label on the left
            VStack(alignment: .leading, spacing: 2) {
                Text(NotificationManager.formatTimeForDisplay(notificationTime.time))
                    .font(.headline)
                
                if notificationTime.isCustom {
                    Text("Custom")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("Default")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Edit button for custom times
            if notificationTime.isCustom {
                Button(action: {
                    isEditing = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Toggle on the right
            Toggle("", isOn: Binding(
                get: { notificationTime.isEnabled },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
        .sheet(isPresented: $isEditing) {
            EditNotificationTimeView(
                isPresented: $isEditing,
                currentTime: notificationTime.time,
                onSave: { newTime in
                    onUpdate(newTime)
                }
            )
        }
    }
}

struct AddNotificationTimeView: View {
    @Binding var isPresented: Bool
    let onAdd: (String) -> Void
    
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Text("Selected time: \(formatSelectedTime(selectedTime))")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.bottom)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Notification Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        let timeString = formatter.string(from: selectedTime)
                        onAdd(timeString)
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func formatSelectedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct EditNotificationTimeView: View {
    @Binding var isPresented: Bool
    let currentTime: String
    let onSave: (String) -> Void
    
    @State private var selectedTime: Date
    
    init(isPresented: Binding<Bool>, currentTime: String, onSave: @escaping (String) -> Void) {
        self._isPresented = isPresented
        self.currentTime = currentTime
        self.onSave = onSave
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self._selectedTime = State(initialValue: formatter.date(from: currentTime) ?? Date())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "",
                    selection: $selectedTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Text("Selected time hello: \(formatSelectedTime(selectedTime))")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.bottom)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Edit Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm"
                        let timeString = formatter.string(from: selectedTime)
                        onSave(timeString)
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func formatSelectedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

#Preview {
    SettingsView()
}
