# iOS Location Permissions Setup

This document describes the iOS configuration required for location services to work properly.

## Required Info.plist Entries

When setting up the iOS project, add the following entries to `ios/Runner/Info.plist`:

### Location Permission Descriptions

```xml
<!-- Location Permissions -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Shongkot needs your location to send accurate coordinates to emergency responders when you activate the SOS button.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Shongkot needs your location in the background to continuously update responders during an active emergency.</string>

<key>NSLocationAlwaysUsageDescription</key>
<string>Shongkot needs your location in the background to provide continuous location updates to emergency responders during an active emergency.</string>
```

### Location Accuracy (iOS 14+)

```xml
<!-- Request full accuracy by default -->
<key>NSLocationTemporaryUsageDescriptionDictionary</key>
<dict>
    <key>EmergencyTracking</key>
    <string>We need precise location to help emergency responders find you quickly.</string>
</dict>
```

## Permission Types

### When In Use
- Requested first when app is opened
- Allows location access only when app is in foreground
- Required for basic SOS functionality

### Always/Background
- Requested after "when in use" is granted
- Allows location tracking in background
- Critical for continuous emergency tracking
- Should only be requested during active emergency

## iOS Configuration Steps

1. **Create Info.plist** (if not exists):
   ```bash
   cd ios/Runner
   # Info.plist will be created by Flutter when you build for iOS
   ```

2. **Add Location Permissions**:
   - Open `ios/Runner/Info.plist` in Xcode or text editor
   - Add the permission descriptions shown above
   - Customize the text to match your app's use case

3. **Update iOS Deployment Target**:
   - Ensure minimum iOS version is 11.0 or higher
   - In `ios/Podfile`, set:
     ```ruby
     platform :ios, '11.0'
     ```

4. **Enable Background Modes** (Optional, for background tracking):
   - Open project in Xcode
   - Select Runner target
   - Go to "Signing & Capabilities"
   - Add "Background Modes" capability
   - Enable "Location updates"

## Best Practices

### Permission Request Flow
1. Request "When in Use" permission when app launches
2. Only request "Always" permission during an active emergency
3. Provide clear explanation before requesting permissions
4. Guide users to settings if permissions are denied

### Battery Optimization
- Use `LocationAccuracy.high` only during active emergencies
- Switch to `LocationAccuracy.balanced` for background tracking
- Implement distance filters to reduce updates
- Stop location updates when emergency is resolved

### Privacy Compliance
- Clearly explain why location is needed
- Only request background location when necessary
- Respect user's permission choices
- Provide option to disable location features

## Testing on iOS

### Simulator Testing
```bash
# Location simulation in iOS simulator
# Use Xcode's location simulation features:
# Debug -> Location -> Custom Location
```

### Device Testing
1. Build and install on physical device
2. Grant location permissions when prompted
3. Test in different scenarios:
   - App in foreground
   - App in background
   - App terminated
4. Monitor battery usage in Settings

## Troubleshooting

### Permissions Not Working
- Verify Info.plist entries are correct
- Check iOS deployment target (>= 11.0)
- Reset permissions: Settings -> General -> Reset -> Reset Location & Privacy

### Background Updates Not Working
- Ensure Background Modes capability is enabled
- Check that "Always" permission is granted
- Verify location updates are active before backgrounding

### Battery Drain
- Review LocationSettings configuration
- Increase distance filter
- Reduce update frequency
- Use `getLastKnownPosition()` when possible

## Resources

- [Apple Location Services Programming Guide](https://developer.apple.com/documentation/corelocation)
- [iOS Location Permission Best Practices](https://developer.apple.com/design/human-interface-guidelines/location)
- [geolocator Package Documentation](https://pub.dev/packages/geolocator)
- [permission_handler Package Documentation](https://pub.dev/packages/permission_handler)
