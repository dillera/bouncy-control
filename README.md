# Bouncy Control

An iOS application for controlling and managing Bouncy Worlds. Built with SwiftUI and following modern iOS development best practices.

## Features

- View and manage multiple Bouncy Worlds
- Start, stop, and restart worlds remotely
- Real-time connection status monitoring
- Clean MVVM architecture
- Modern SwiftUI interface
- Support for iOS 17.0+

## Requirements

- Xcode 15.0 or later
- iOS 17.0 or later
- macOS for development
- Active Apple Developer account (for device deployment)

## Project Structure

```
BouncyControl/
├── BouncyControl.xcodeproj/     # Xcode project file
├── BouncyControl/
│   ├── BouncyControlApp.swift   # App entry point
│   ├── Info.plist               # App configuration
│   ├── Source/
│   │   ├── Models/              # Data models
│   │   │   └── BouncyWorld.swift
│   │   ├── Views/               # SwiftUI views
│   │   │   ├── ContentView.swift
│   │   │   └── ControlPanelView.swift
│   │   ├── ViewModels/          # Business logic
│   │   │   └── BouncyControlViewModel.swift
│   │   └── Services/            # Network & utilities
│   │       └── NetworkService.swift
│   └── Resources/
│       ├── Assets.xcassets/     # Images and colors
│       └── Preview Content/     # SwiftUI preview assets
├── BouncyControlTests/          # Unit tests (to be added)
└── BouncyControlUITests/        # UI tests (to be added)
```

## Getting Started

### Opening the Project

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd bouncy-control
   ```

2. Open the project in Xcode:
   ```bash
   open BouncyControl.xcodeproj
   ```

3. Select your target device or simulator from the Xcode toolbar

4. Build and run the project (Cmd + R)

### Building from Command Line

You can build the project using `xcodebuild`:

```bash
# Build for simulator
xcodebuild -project BouncyControl.xcodeproj \
           -scheme BouncyControl \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build

# Build for device (requires code signing setup)
xcodebuild -project BouncyControl.xcodeproj \
           -scheme BouncyControl \
           -sdk iphoneos \
           build
```

## Configuration

### API Endpoint

The app connects to the Bouncy Worlds API. The default endpoint is configured in `NetworkService.swift`:

```swift
private let baseURL: String = "https://api.bouncyworlds.com"
```

To change the API endpoint, modify the `baseURL` property or pass a custom URL when initializing the service.

### Code Signing

For deploying to a physical device:

1. Open the project in Xcode
2. Select the BouncyControl target
3. Go to "Signing & Capabilities"
4. Select your development team
5. Ensure "Automatically manage signing" is checked

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** pattern:

- **Models**: Data structures representing Bouncy Worlds and API responses
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: Network communication and utilities

### Key Components

- **BouncyWorld**: Model representing a world with its properties
- **BouncyControlViewModel**: Main view model handling world management
- **NetworkService**: Handles all API communication
- **ContentView**: Main screen showing world list
- **ControlPanelView**: Detail screen for controlling individual worlds

## Development

### Mock Data

The app includes mock data that loads automatically if the API is unavailable. This allows for development and testing without a live backend.

### Adding New Features

1. Create models in `Source/Models/`
2. Add business logic to ViewModels in `Source/ViewModels/`
3. Create UI in `Source/Views/`
4. Add network calls to `NetworkService.swift`

### SwiftUI Previews

All views include SwiftUI preview providers for rapid development:

```swift
#Preview {
    ContentView()
}
```

## Testing

### Unit Tests

Run unit tests with:
```bash
xcodebuild test -project BouncyControl.xcodeproj \
                -scheme BouncyControl \
                -destination 'platform=iOS Simulator,name=iPhone 15'
```

Or use Xcode: Cmd + U

### UI Tests

UI tests can be run similarly or through Xcode's test navigator.

## Deployment

### TestFlight

1. Archive the app (Product > Archive in Xcode)
2. Upload to App Store Connect
3. Configure TestFlight testing
4. Invite testers

### App Store

1. Complete App Store Connect listing
2. Submit for review
3. Wait for Apple approval

## Troubleshooting

### Build Errors

- Ensure you're using Xcode 15.0 or later
- Clean build folder: Shift + Cmd + K
- Clear derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

### Signing Issues

- Verify your Apple Developer account is active
- Check that your certificates are valid
- Ensure the bundle identifier is unique

### Simulator Issues

- Reset simulator: Device > Erase All Content and Settings
- Restart Xcode
- Update to latest iOS simulator runtime

## API Documentation

The app expects the following API endpoints:

- `GET /worlds` - Fetch all worlds
- `POST /worlds/{id}/start` - Start a world
- `POST /worlds/{id}/stop` - Stop a world
- `POST /worlds/{id}/restart` - Restart a world

### Example Response Format

```json
{
  "worlds": [
    {
      "id": "world-001",
      "name": "Gravity Garden",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z"
    }
  ],
  "count": 1
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

[Add your license here]

## Support

For issues and questions:
- Open an issue on GitHub
- Contact support at [your-email]

## Changelog

### Version 1.0 (Current)
- Initial release
- World listing and management
- Start/stop/restart controls
- MVVM architecture
- SwiftUI interface
