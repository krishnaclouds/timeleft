# Simple Widget Setup Guide

## Overview

This guide shows how to add a simple, guaranteed-to-work widget to your Timeleft app. The simple widget shows:

- Current day of the year
- Year progress percentage  
- Motivational messaging
- Beautiful floral theme matching your app
- No complex configuration required

## Setup Steps

### 1. Add Widget Extension Target

1. Open `timeleft.xcodeproj` in Xcode
2. Go to **File > New > Target**
3. Select **Widget Extension** from iOS section
4. Configure:
   - **Product Name**: `SimpleTimeleftWidget`
   - **Bundle Identifier**: `com.koffeecuptales.timeleft.SimpleTimeleftWidget`
   - **Include Configuration Intent**: ❌ **Leave unchecked**
5. Click **Finish**
6. Click **Activate** when prompted

### 2. Replace Generated Code

1. **Delete** the auto-generated `SimpleTimeleftWidget.swift` file
2. **Copy** the file `SimpleWidget/SimpleTimeleftWidget.swift` into the widget target folder in Xcode
3. **Make sure** it's added to the `SimpleTimeleftWidget` target

### 3. Build and Test

1. Select the `SimpleTimeleftWidget` scheme in Xcode
2. Choose a simulator or device
3. Build and run (Cmd+R)
4. This will show the widget configuration screen

### 4. Add to Home Screen

1. **On your device/simulator**:
   - Long press on home screen
   - Tap the **+** button
   - Search for "Timeleft"
   - Select Small or Medium size
   - Tap **Add Widget**

## Widget Features

### Small Widget
- App icon and name
- Current day of year (e.g., "Day 207")
- Total days in year
- "Make it count" motivational text

### Medium Widget  
- App branding with icon
- "Every moment matters" tagline
- Day progress with visual progress bar
- Percentage complete for the year

## Design
- Floral gradient background matching main app
- Purple and pink color scheme
- Subtle decorative elements
- Clean, readable typography

## Benefits

✅ **Simple Setup**: No App Groups or complex configuration  
✅ **Guaranteed Build**: Uses only standard iOS widget APIs  
✅ **Motivational**: Encourages time awareness  
✅ **Beautiful**: Matches your app's floral design  
✅ **Universal**: Shows relevant info without needing specific events  

## Troubleshooting

**Widget doesn't appear**: 
- Make sure the widget target built successfully
- Check that the bundle identifier is correct
- Try cleaning build folder (Shift+Cmd+K) and rebuilding

**Widget shows blank**:
- Ensure `SimpleTimeleftWidget.swift` is in the correct target
- Verify the widget scheme is selected when building

**Build errors**:
- Make sure you selected "Widget Extension" and not "App Intent Extension"
- Ensure iOS Deployment Target matches main app (18.5+)

## Next Steps

Once this simple widget is working, you can optionally upgrade to the full-featured widget with event selection by following the `WIDGET_SETUP_GUIDE.md`.

The simple widget provides immediate value while being much easier to set up!