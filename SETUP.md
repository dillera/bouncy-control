# BouncyControl - Setup Guide

This document provides step-by-step instructions to get started with the BouncyControl iOS application.

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later installed
- Command Line Tools for Xcode
- An Apple ID (for running on physical devices)

## Quick Start

### 1. Open the Project

```bash
cd /Users/dillera/code/bouncy-control
open BouncyControl.xcodeproj
```

This will launch Xcode with the project loaded.

### 2. Select a Destination

In Xcode's toolbar, click on the destination selector and choose either:
- An iOS Simulator (e.g., iPhone 15)
- Your connected iOS device (requires signing setup)

### 3. Build and Run

Press `Cmd + R` or click the play button in Xcode's toolbar.

The app will build and launch in the simulator or on your device.

## Using Build Scripts

The project includes convenient build scripts in the `scripts/` directory:

### Build for Simulator

```bash
./scripts/build.sh simulator
```

### Build for Device

```bash
./scripts/build.sh device
```

### Run Tests

```bash
./scripts/test.sh
```

### Run Linter

```bash
./scripts/lint.sh        # Check code style
./scripts/lint.sh fix    # Auto-fix issues
```

## Code Signing Setup

To run on a physical iOS device:

1. Open `BouncyControl.xcodeproj` in Xcode
2. Select the `BouncyControl` target in the project navigator
3. Go to the "Signing & Capabilities" tab
4. Under "Team", select your Apple Developer account
5. Ensure "Automatically manage signing" is checked
6. If needed, change the Bundle Identifier to make it unique (e.g., `com.yourname.BouncyControl`)

## Project Structure Overview

```
BouncyControl/
├── BouncyControl/
│   ├── BouncyControlApp.swift          # App entry point
│   ├── Info.plist                       # App metadata
│   ├── Source/
│   │   ├── Models/                      # Data models
│   │   ├── Views/                       # SwiftUI views
│   │   ├── ViewModels/                  # Business logic
│   │   └── Services/                    # Networking
│   └── Resources/                       # Assets, previews
├── scripts/                             # Build automation
├── .github/workflows/                   # CI/CD pipelines
└── BouncyControl.xcodeproj/            # Xcode project
```

## Key Features

### MVVM Architecture

The app follows Model-View-ViewModel pattern:

- **Models** (`BouncyWorld.swift`): Define data structures
- **Views** (`ContentView.swift`, `ControlPanelView.swift`): UI components
- **ViewModels** (`BouncyControlViewModel.swift`): Business logic
- **Services** (`NetworkService.swift`): API communication

### Mock Data

The app includes mock data for development. When the API is unavailable, it automatically loads three sample worlds:
- Gravity Garden
- Elastic Empire
- Spring Valley

### Network Configuration

Default API endpoint: `https://api.bouncyworlds.com`

To change the endpoint, edit `BouncyControl/Source/Services/NetworkService.swift:17`:

```swift
init(baseURL: String = "YOUR_API_URL", session: URLSession = .shared) {
```

## Building from Command Line

### Build for Simulator

```bash
xcodebuild -project BouncyControl.xcodeproj \
           -scheme BouncyControl \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build
```

### Build for Device

```bash
xcodebuild -project BouncyControl.xcodeproj \
           -scheme BouncyControl \
           -sdk iphoneos \
           -configuration Release \
           build
```

## Troubleshooting

### "No such module" errors

1. Clean the build folder: `Shift + Cmd + K`
2. Close Xcode
3. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
4. Reopen the project

### Simulator not showing

1. Open Xcode → Window → Devices and Simulators
2. Add a new simulator if needed
3. Restart Xcode

### Code signing errors

1. Go to Preferences → Accounts
2. Sign in with your Apple ID
3. Download manual profiles if needed
4. Select your team in project settings

### Build fails with plugin error

Run Xcode first launch setup:
```bash
xcodebuild -runFirstLaunch
```

## Next Steps

1. **Customize the API endpoint** in `NetworkService.swift`
2. **Add your app icon** to `Resources/Assets.xcassets/AppIcon.appiconset/`
3. **Configure push notifications** if needed
4. **Add unit tests** in `BouncyControlTests/`
5. **Set up continuous integration** using the included GitHub Actions workflows

## Development Workflow

1. Make changes to source files
2. Use SwiftUI previews for rapid iteration (`Cmd + Option + P`)
3. Run the app in simulator to test (`Cmd + R`)
4. Run tests before committing (`Cmd + U`)
5. Run linter to check code style (`./scripts/lint.sh`)
6. Commit changes and push to repository

## CI/CD

The project includes GitHub Actions workflows:

- **iOS Build and Test** (`.github/workflows/ios-build.yml`)
  - Runs on every push and pull request
  - Builds the app for simulator
  - Runs all tests

- **SwiftLint** (`.github/workflows/swiftlint.yml`)
  - Checks code style
  - Runs on every push and pull request

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [iOS App Distribution Guide](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Xcode Help](https://help.apple.com/xcode/)

## Support

If you encounter issues:
1. Check the [README.md](README.md) for general information
2. Review this setup guide
3. Check Xcode console for error messages
4. Open an issue on the repository

---

**Happy coding!** 🚀
