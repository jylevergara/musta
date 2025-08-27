# Musta iOS App Setup Guide

## Xcode Configuration

### 1. Project Settings
1. Open `musta.xcodeproj` in Xcode
2. Select the project in the navigator
3. Go to the "Signing & Capabilities" tab
4. Add your development team
5. Set Bundle Identifier (e.g., `com.yourname.musta`)

### 2. Enable Push Notifications
1. In the "Signing & Capabilities" tab
2. Click "+ Capability"
3. Add "Push Notifications"
4. This enables local notifications for daily reminders

### 3. iOS Deployment Target
- Set to iOS 15.0+ as specified
- This ensures compatibility with all SwiftUI features used

### 4. Add Files to Bundle
Make sure the following files are included in your app bundle:
- `musta/Resources/languageData.json` - Language phrases data
- `musta/Info.plist` - App configuration

### 5. Build and Run
1. Select your target device or simulator
2. Press Cmd+R to build and run
3. The app should launch with the tab interface

## App Features Verification

### Home Tab
- ✅ Displays flashcards with antiquewhite background
- ✅ Shows language header with flag and name
- ✅ Includes humorous subtitle
- ✅ Pull-to-refresh functionality
- ✅ Loading and error states

### Language Tab
- ✅ Lists all available languages (Filipino, French, Cebuano)
- ✅ Shows flags, names, and native names
- ✅ Checkmarks for selected language
- ✅ Instant language switching

### Settings Tab
- ✅ Notification permission handling
- ✅ Default notification times (8:00 AM, 8:00 PM)
- ✅ Add custom notification times
- ✅ Edit and delete functionality
- ✅ Toggle switches for enabling/disabling

## Testing Notifications

### Simulator Testing
1. Run the app in simulator
2. Go to Settings tab
3. Enable notifications
4. Add a custom time for testing
5. Wait for the notification to appear

### Device Testing
1. Install on physical device
2. Grant notification permissions when prompted
3. Set notification times
4. Notifications will appear at scheduled times

## Troubleshooting

### Common Issues

**App crashes on launch:**
- Check that `languageData.json` is included in bundle
- Verify all Swift files are added to target

**Notifications not working:**
- Ensure Push Notifications capability is added
- Check notification permissions in device settings
- Verify notification times are properly formatted

**Language data not loading:**
- Check JSON file syntax
- Verify file is included in app bundle
- Check console for decoding errors

### Debug Tips

1. **Console Logging**: Check Xcode console for error messages
2. **Breakpoints**: Set breakpoints in LanguageManager and NotificationManager
3. **Simulator Reset**: Reset simulator if notifications aren't working
4. **Clean Build**: Cmd+Shift+K to clean build folder

## Performance Notes

- LazyVStack used for efficient flashcard rendering
- UserDefaults for lightweight data persistence
- Proper memory management with weak references
- Background notification processing

## Accessibility

The app includes:
- Proper accessibility labels
- VoiceOver support
- Dynamic Type compatibility
- High contrast mode support

## App Store Preparation

Before submitting to App Store:
1. Update app icons in Assets.xcassets
2. Add app privacy policy
3. Test on multiple devices
4. Verify all notification scenarios
5. Check accessibility compliance

## Support

For issues or questions:
1. Check the README.md for detailed documentation
2. Review the code comments for implementation details
3. Test with the provided unit tests
4. Verify against the original specifications
