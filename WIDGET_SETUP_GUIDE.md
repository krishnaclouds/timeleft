# Timeleft Widget Setup Guide

This guide explains how to add the widget extension to your Xcode project.

## Files Created

The following files have been created for the widget implementation:

### Widget Extension Files
- `TimeleftWidget/TimeleftWidget.swift` - Main widget implementation
- `TimeleftWidget/IntentHandler.swift` - Intent handler for event selection
- `TimeleftWidget/Intents.intentdefinition` - Intent definition file
- `TimeleftWidget/TimeleftWidget.entitlements` - Widget entitlements
- `TimeleftWidget/Info.plist` - Widget Info.plist

### Shared Code Files
- `SharedModels.swift` - Shared data models and utilities

### Updated Files
- `timeleft/timeleft.entitlements` - Updated with app group capability
- `timeleft/ContentView.swift` - Updated to sync data with widget

## Manual Xcode Setup Steps

Since I cannot directly modify the Xcode project file, you'll need to follow these steps:

### 1. Add Widget Extension Target

1. In Xcode, go to **File > New > Target**
2. Select **Widget Extension** from the iOS section
3. Configure the widget extension:
   - **Product Name**: `TimeleftWidget`
   - **Bundle Identifier**: `com.koffeecuptales.timeleft.TimeleftWidget`
   - **Include Configuration Intent**: ✅ **Check this box**
4. Click **Finish**
5. When prompted about activating the scheme, click **Activate**

### 2. Replace Generated Files

Replace the auto-generated files with the ones created:

1. **Delete** the auto-generated files in the `TimeleftWidget` folder:
   - `TimeleftWidget.swift`
   - `IntentHandler.swift` 
   - `TimeleftWidget.intentdefinition`

2. **Add** the new files to the `TimeleftWidget` target:
   - Drag `TimeleftWidget/TimeleftWidget.swift` to the `TimeleftWidget` folder in Xcode
   - Drag `TimeleftWidget/IntentHandler.swift` to the `TimeleftWidget` folder in Xcode
   - Drag `TimeleftWidget/Intents.intentdefinition` to the `TimeleftWidget` folder in Xcode
   - Make sure all files are added to the `TimeleftWidget` target

### 3. Add Shared Files

1. **Add** `SharedModels.swift` to **both** the main app target and the widget extension target:
   - Drag `SharedModels.swift` to the project
   - In the dialog, ensure both `timeleft` and `TimeleftWidget` targets are checked

### 4. Configure App Groups

1. **For the main app**:
   - Select the `timeleft` target
   - Go to **Signing & Capabilities**
   - Click **+ Capability** and add **App Groups**
   - Add the app group: `group.com.koffeecuptales.timeleft`

2. **For the widget extension**:
   - Select the `TimeleftWidget` target
   - Go to **Signing & Capabilities**
   - Click **+ Capability** and add **App Groups**
   - Add the same app group: `group.com.koffeecuptales.timeleft`

### 5. Update Build Settings

1. **For the widget extension**:
   - Select the `TimeleftWidget` target
   - Go to **Build Settings**
   - Set **iOS Deployment Target** to **18.5** (or your minimum target)
   - Ensure **Swift Language Version** is set to **Swift 5**

### 6. Update Info.plist Files

1. **Widget Extension Info.plist**:
   - The `TimeleftWidget/Info.plist` should already be configured correctly
   - Make sure it's set as the Info.plist for the `TimeleftWidget` target

2. **Widget Entitlements**:
   - Set `TimeleftWidget/TimeleftWidget.entitlements` as the entitlements file for the `TimeleftWidget` target

## Testing the Widget

### 1. Build and Run

1. Select the `TimeleftWidget` scheme in Xcode
2. Choose a simulator or device
3. Build and run (Cmd+R)
4. This will launch the widget configuration screen

### 2. Add Widget to Home Screen

1. **On Simulator/Device**:
   - Long press on the home screen
   - Tap the **+** button in the top-left corner
   - Search for "Timeleft"
   - Select the widget size you want (Small, Medium, or Large)
   - Tap **Add Widget**

2. **Configure Widget**:
   - After adding, tap on the widget to configure it
   - Select which event you want to display
   - Tap **Done**

### 3. Widget Features

The widget supports three sizes:

- **Small Widget**: Shows event name and compact time remaining
- **Medium Widget**: Shows event name, date, and time breakdown with time unit cards
- **Large Widget**: Shows full event details with mini dot visualization

## Widget Functionality

### Event Selection
- Users can configure which event to display in the widget
- The configuration interface shows all available events
- Events are dynamically loaded from the shared app group

### Time Display
- **≤30 days**: Shows days only
- **31-90 days**: Shows weeks and days
- **>90 days**: Shows months, weeks, and days
- **Overdue events**: Shows "OVERDUE" with days past

### Visual Design
- Matches the app's floral theme
- Uses the same color scheme (orange, purple, blue)
- Ultra-thin material effects for glass morphism
- Gradient backgrounds and borders

### Data Synchronization
- Widget data is automatically updated when events are added/edited/deleted in the main app
- Uses App Groups for secure data sharing
- Updates every hour or when the app is opened

## Troubleshooting

### Common Issues

1. **Widget doesn't appear in widget gallery**:
   - Make sure the widget extension target is built successfully
   - Check that App Groups are configured correctly
   - Verify the bundle identifier is correct

2. **Widget shows "No Events"**:
   - Ensure events are created in the main app
   - Check that App Groups capability is enabled for both targets
   - Verify the app group identifier matches in both targets

3. **Configuration doesn't show events**:
   - Make sure `SharedModels.swift` is added to both targets
   - Check that the Intent definition file is correctly configured
   - Verify the IntentHandler is properly implemented

4. **Widget doesn't update**:
   - Check that data is being synced from the main app
   - Verify App Groups are working correctly
   - Try force-refreshing the widget by removing and re-adding it

### Build Errors

If you encounter build errors:

1. **Ensure all files are added to correct targets**
2. **Check import statements** - make sure all required frameworks are linked
3. **Verify deployment targets** match between main app and widget
4. **Clean build folder** (Shift+Cmd+K) and rebuild

## Additional Notes

- The widget uses the new iOS 18.5+ widget features
- It supports all device sizes and orientations
- The configuration interface is built with Intents framework
- Widget timeline updates every hour to keep time calculations current
- All UI components use SwiftUI and maintain the app's design consistency

## Future Enhancements

Potential improvements for the widget:

1. **Multiple Event Display**: Show multiple events in larger widgets
2. **Customizable Colors**: Allow users to choose widget theme colors
3. **Interactive Elements**: Add buttons for quick actions
4. **Time Zone Support**: Handle events in different time zones
5. **Complications**: Add support for Apple Watch complications

The widget is now ready to use and provides a convenient way for users to keep track of their important events right from their home screen!