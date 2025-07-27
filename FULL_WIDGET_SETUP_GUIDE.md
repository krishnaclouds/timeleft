# Full-Featured Widget Setup Guide

## Overview

This guide walks you through setting up the complete widget implementation with:
- Event data synchronization between app and widget
- Beautiful floral theme matching your app
- Small, Medium, and Large widget sizes
- Time unit cards with glass morphism effects
- Mini dot visualization in Large widgets

## Prerequisites

✅ **Main app is building successfully**  
✅ **All widget files are created**  
✅ **Entitlements are configured for App Groups**

## Setup Steps

### 1. Add Widget Extension Target

1. **Open** `timeleft.xcodeproj` in Xcode
2. **Go to** File → New → Target
3. **Select** Widget Extension (iOS)
4. **Configure**:
   - Product Name: `TimeleftWidget`
   - Bundle Identifier: `com.koffeecuptales.timeleft.TimeleftWidget`
   - Include Configuration Intent: ❌ **Leave unchecked**
5. **Click** Finish
6. **Click** Activate when prompted

### 2. Add Shared Files to Both Targets

1. **Add SharedModels.swift to both targets**:
   - Drag `timeleft/SharedModels.swift` into Xcode
   - ✅ Check **both** `timeleft` and `TimeleftWidget` targets
   - Click Add

2. **Replace widget implementation**:
   - Delete the auto-generated `TimeleftWidget.swift`
   - Drag `TimeleftWidget/TimeleftWidget.swift` into the widget target
   - ✅ Make sure it's added to `TimeleftWidget` target only

### 3. Configure App Groups

1. **For main app** (timeleft target):
   - Select `timeleft` target
   - Go to Signing & Capabilities
   - Click + Capability → App Groups
   - Add: `group.com.koffeecuptales.timeleft`

2. **For widget** (TimeleftWidget target):
   - Select `TimeleftWidget` target  
   - Go to Signing & Capabilities
   - Click + Capability → App Groups
   - Add: `group.com.koffeecuptales.timeleft`

### 4. Build and Test

1. **Build main app first**:
   - Select `timeleft` scheme
   - Build and run (Cmd+R)
   - Add some events to test with

2. **Build widget**:
   - Select `TimeleftWidget` scheme
   - Build and run (Cmd+R)
   - This opens widget configuration

## Widget Features

### 🔄 **Automatic Data Sync**
- Events automatically sync from app to widget
- Widget shows first event in your list
- Updates every hour

### 🎨 **Three Widget Sizes**

**Small Widget:**
- Event name
- Time remaining (e.g., "30 days left" or "2m 1w 3d")
- Compact floral background

**Medium Widget:**
- Event name and date
- Time unit cards with glass effects
- Subtle floral decorations
- "remaining" text

**Large Widget:**
- Full event display
- Time unit cards
- Mini dot visualization
- Complete floral theme

### 🎯 **Smart Time Display**
- **≤30 days**: Shows days only
- **31-90 days**: Shows weeks + days  
- **>90 days**: Shows months + weeks + days
- **Overdue**: Shows "OVERDUE" with days past

## Using the Widget

### 1. Add to Home Screen
1. Long press home screen
2. Tap + button
3. Search "Timeleft"
4. Choose widget size
5. Tap Add Widget

### 2. Widget Updates
- Shows your first event automatically
- Updates every hour
- Syncs when you modify events in app

## Troubleshooting

### Widget Shows "No Events Yet"
**Fix**: Make sure you have events in the main app and App Groups are configured correctly.

### Widget Not Updating
**Fix**: 
1. Remove and re-add the widget
2. Check App Groups configuration
3. Ensure both targets have the same group ID

### Build Errors
**Fix**:
1. Clean build folder (Shift+Cmd+K)
2. Make sure SharedModels.swift is in both targets
3. Check deployment targets match (iOS 18.5+)

### Widget Shows Wrong Event
**Current behavior**: Widget shows the first event in your list (sorted by date). In a future update, you could add event selection.

## Files Structure

```
timeleft/
├── timeleft/
│   ├── SharedModels.swift          # Shared between app and widget
│   ├── ContentView.swift           # Updated with widget sync
│   └── timeleft.entitlements       # App Groups enabled
├── TimeleftWidget/
│   ├── TimeleftWidget.swift        # Full widget implementation
│   └── TimeleftWidget.entitlements # App Groups enabled
└── README.md                       # Updated with widget features
```

## Technical Details

### Data Synchronization
- Uses UserDefaults with App Groups
- Fallback to standard UserDefaults if App Groups unavailable
- JSON encoding/decoding for event data
- Logging for debugging sync issues

### Widget Updates
- TimelineProvider updates every hour
- StaticConfiguration (no user configuration needed)
- Three widget families supported
- Floral theme matches main app perfectly

## Next Steps

Once your widget is working:

1. **Test all sizes** - Add Small, Medium, and Large widgets
2. **Test data sync** - Add/edit events in app, check widget updates
3. **Customize appearance** - Modify colors or layouts if desired

The widget will show your events beautifully with the same floral theme as your app! 🌸

---

**Need help?** Check the console logs - SharedDataManager prints sync information to help debug any issues.