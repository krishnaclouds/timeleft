# timeleft - iOS SwiftUI Time Tracking App

## Project Overview
**timeleft** is a simple iOS SwiftUI application that helps users visualize time remaining until a target date. The app features a clean interface with a date picker and a dot-based visual representation of time progression.

## Architecture

### Core Components
- **timeleftApp.swift**: Main app entry point using SwiftUI `@main` App protocol
- **ContentView.swift**: Primary view containing:
  - Date picker for target date selection
  - Time calculation logic
  - DotVisualizationView integration
- **DotVisualizationView**: Custom SwiftUI view that displays progress as a grid of colored dots

### Key Features
- Target date selection with validation (future dates only)
- Real-time calculation of remaining days
- Visual progress representation using colored dots (gray for passed days, blue for remaining)
- Responsive LazyVGrid layout (10 columns, configurable)
- Clean, modern SwiftUI interface with system colors and typography

## Build System & Configuration

### Xcode Project Structure
- **Build System**: Xcode 16.4+ project (`.xcodeproj`)
- **Swift Version**: 5.0
- **Deployment Targets**:
  - iOS: 18.5+
  - macOS: 15.5+
  - visionOS: 2.5+
- **Supported Platforms**: iPhone, iPad, Mac, Apple Vision Pro
- **Bundle ID**: `com.koffeecuptales.timeleft`

### Project Targets
1. **timeleft** (main app)
2. **timeleftTests** (unit tests using new Swift Testing framework)
3. **timeleftUITests** (UI tests)

### App Capabilities
- App Sandbox enabled
- File access: user-selected read-only files
- SwiftUI Previews enabled
- No external dependencies or Swift Package Manager usage

## Development Commands

### Building & Running
```bash
# Build the project
xcodebuild -project timeleft.xcodeproj -scheme timeleft -configuration Debug build

# Build for release
xcodebuild -project timeleft.xcodeproj -scheme timeleft -configuration Release build

# Run on iOS Simulator
xcodebuild -project timeleft.xcodeproj -scheme timeleft -destination 'platform=iOS Simulator,name=iPhone 15' build test

# Run on macOS
xcodebuild -project timeleft.xcodeproj -scheme timeleft -destination 'platform=macOS' build
```

### Testing
```bash
# Run unit tests
xcodebuild test -project timeleft.xcodeproj -scheme timeleft -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests specifically
xcodebuild test -project timeleft.xcodeproj -scheme timeleft -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:timeleftUITests

# Run unit tests only
xcodebuild test -project timeleft.xcodeproj -scheme timeleft -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:timeleftTests
```

### Code Analysis
```bash
# Analyze code for issues
xcodebuild analyze -project timeleft.xcodeproj -scheme timeleft -configuration Debug

# Archive for distribution
xcodebuild archive -project timeleft.xcodeproj -scheme timeleft -archivePath timeleft.xcarchive
```

## File Structure
```
timeleft/
├── timeleft.xcodeproj/          # Xcode project file
├── timeleft/                    # Main app source
│   ├── timeleftApp.swift        # App entry point
│   ├── ContentView.swift        # Main UI + business logic
│   ├── Assets.xcassets/         # App icons, colors, images
│   └── timeleft.entitlements    # App capabilities
├── timeleftTests/               # Unit tests (Swift Testing)
│   └── timeleftTests.swift
└── timeleftUITests/             # UI automation tests
    ├── timeleftUITests.swift
    └── timeleftUITestsLaunchTests.swift
```

## Code Patterns & Conventions

### SwiftUI Architecture
- Single-file architecture with main logic in `ContentView`
- State management using `@State` property wrappers
- Custom view components (DotVisualizationView) as separate structs
- SwiftUI Preview support with `#Preview` macro

### Key Code Patterns
```swift
// State management
@State private var selectedDate = Date()
@State private var currentDate = Date()

// Computed properties for business logic
private var daysRemaining: Int { ... }
private var totalDaysInPeriod: Int { ... }

// Custom view components
struct DotVisualizationView: View { ... }
```

### Testing Framework
- Uses new Swift Testing framework (not XCTest)
- Test structure: `@Test func example() async throws`
- Async test support built-in

## Development Notes

### Current State
- Single-view application with core time tracking functionality
- No data persistence (state resets on app restart)
- No external dependencies
- Basic test structure in place but minimal test coverage

### Potential Enhancement Areas
- Data persistence (Core Data/SwiftData)
- Multiple target dates support
- Notifications for milestones
- Customizable themes/colors
- Export functionality
- Widget support

### Xcode-Specific Notes
- Project uses new Xcode 16.4 file system synchronized groups
- SwiftUI previews work out of the box
- Universal app supporting all Apple platforms
- Automatic code signing configured

## Quick Start for Development
1. Open `timeleft.xcodeproj` in Xcode 16.4+
2. Select target device/simulator
3. Build and run (Cmd+R)
4. Make changes to `ContentView.swift` for UI modifications
5. Use SwiftUI previews for rapid iteration
6. Run tests with Cmd+U

## Bundle Information
- **Product Name**: timeleft
- **Version**: 1.0 (1)
- **Creator**: Bala Krishna
- **Created**: July 25, 2025
- **App Group Registration**: Enabled