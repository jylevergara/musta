# Musta - Language Learning App

A native iOS app built with SwiftUI for learning Filipino, French, and Cebuano phrases through flashcards and daily notifications.

## Features

### 🏠 Home Tab (Flashcards)
- **Interactive Flashcards**: Beautiful antiquewhite cards displaying phrases and translations
- **Language Header**: Shows selected language with flag, name, and native name
- **Humorous Subtitle**: "Learn this language or forever be trapped in tourist restaurants with pictures on the menu."
- **Pull-to-Refresh**: Refresh language data with swipe gesture
- **Loading States**: Proper loading indicators and error handling

### 🌍 Language Selection
- **Multi-language Support**: Filipino, French, and Cebuano
- **Visual Language Cards**: Flag, name, and native name display
- **Instant Switching**: Tap to change language with immediate persistence
- **Selection Indicators**: Checkmarks show currently selected language

### ⚙️ Settings & Notifications
- **Smart Notifications**: Daily reminders with random phrases from selected language
- **Customizable Times**: Add, edit, and delete notification times
- **Default Times**: 8:00 AM and 8:00 PM pre-configured
- **Permission Handling**: Proper notification permission requests
- **Swipe-to-Delete**: Remove custom notification times with swipe gesture

## Technical Architecture

### 📱 App Structure
- **SwiftUI Framework**: Modern declarative UI framework
- **MVVM Architecture**: Clean separation of concerns
- **ObservableObject**: Reactive state management with Combine
- **TabView Navigation**: Three-tab interface (Home, Language, Settings)

### 🗄️ Data Management
- **JSON Bundle**: Language data stored in app bundle
- **UserDefaults**: Simple data persistence for settings
- **Core Data Ready**: Architecture supports complex data relationships
- **Offline Capability**: All data stored locally

### 🔔 Notification System
- **UNUserNotificationCenter**: Native iOS notification framework
- **Daily Repeating**: Scheduled notifications with random phrase selection
- **Permission Handling**: Proper authorization flow with user guidance
- **Background Support**: Notifications work when app is closed

## Project Structure

```
Musta/
├── mustaApp.swift              # App entry point
├── ContentView.swift           # Main tab view
├── Models/
│   ├── Language.swift          # Language data model
│   └── NotificationTime.swift  # Notification time model
├── Views/
│   ├── HomeView.swift          # Flashcards view
│   ├── FlashCard.swift         # Individual flashcard component
│   ├── LanguageSelectionView.swift # Language selection
│   └── SettingsView.swift      # Settings and notifications
├── ViewModels/
│   ├── LanguageManager.swift   # Language state management
│   └── NotificationManager.swift # Notification management
├── Services/
│   ├── DataService.swift       # JSON data loading
│   └── NotificationService.swift # Notification scheduling
├── Resources/
│   └── languageData.json       # Language phrases data
└── Supporting Files/
    ├── Info.plist              # App configuration
    └── Assets.xcassets         # App icons and colors
```

## Supported Languages

### 🇵🇭 Filipino (Tagalog)
- 12 essential phrases
- Common greetings and expressions
- Cultural phrases like "Sana all!"

### 🇫🇷 French
- 12 practical phrases
- Pronunciation guides included
- Numbers and common expressions

### 🇵🇭 Cebuano (Bisaya)
- 20 comprehensive phrases
- Regional language of the Philippines
- Essential travel and daily phrases

## Setup Instructions

### Prerequisites
- Xcode 14.0+
- iOS 15.0+ deployment target
- Swift 5.0+

### Installation
1. Clone the repository
2. Open `musta.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on device or simulator

### Configuration
- **Push Notifications**: Enable capability in Xcode project settings
- **Core Data**: Ready for implementation if needed
- **App Icons**: Update Assets.xcassets with your app icons

## Key Features Implementation

### Flashcard System
- LazyVStack for performance with large phrase sets
- Antiquewhite background color (#FAEBD6)
- Responsive design with proper spacing
- Accessibility support

### Notification Management
- Singleton pattern for global notification state
- UserDefaults persistence for notification times
- Proper permission flow with user guidance
- Random phrase selection for variety

### Language Switching
- Immediate UI updates with SwiftUI
- Persistent selection across app launches
- Automatic notification language updates
- Clean state management

## Design Principles

### iOS Native Design
- SF Symbols for consistent iconography
- Native navigation patterns
- Proper alert dialogs and sheets
- iOS Human Interface Guidelines compliance

### User Experience
- Intuitive tab-based navigation
- Visual feedback for all interactions
- Loading states and error handling
- Accessibility considerations

### Performance
- Lazy loading for large datasets
- Efficient state management
- Background notification processing
- Memory-conscious data handling

## Future Enhancements

- **Core Data Integration**: For complex data relationships
- **Offline Sync**: CloudKit integration for cross-device sync
- **Audio Pronunciation**: Text-to-speech for phrase pronunciation
- **Progress Tracking**: Learning progress and statistics
- **More Languages**: Expand language support
- **Gamification**: Points, streaks, and achievements

## Contributing

This project follows iOS development best practices and Apple's Human Interface Guidelines. Contributions should maintain code quality and user experience standards.

## License

This project is created for educational and personal use. Please respect the original specifications and requirements.
