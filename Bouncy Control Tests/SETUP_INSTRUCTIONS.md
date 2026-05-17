# Test Target Setup Instructions

This guide will help you add the test target to your Xcode project.

## Quick Setup (Recommended)

### Option 1: Using Xcode UI

1. **Open the project in Xcode**
   ```bash
   open "Bouncy Control.xcodeproj"
   ```

2. **Add a new test target**
   - File → New → Target...
   - Choose "iOS" → "Unit Testing Bundle"
   - Click "Next"

3. **Configure the test target**
   - Product Name: `Bouncy Control Tests`
   - Team: Select your development team
   - Organization Identifier: Use your existing identifier
   - Click "Finish"
   - When prompted "Would you like to activate the scheme?", click "Activate"

4. **Delete the default test file**
   - Xcode will create a default test file - you can delete it
   - We've already created all the test files you need

5. **Add existing test files to the target**
   - In the Project Navigator, select the "Bouncy Control Tests" folder you see in Finder
   - Click File → Add Files to "Bouncy Control"...
   - Navigate to the "Bouncy Control Tests" directory
   - Select all `.swift` test files:
     - NetworkServiceTests.swift
     - ControlViewModelTests.swift
     - ServerTests.swift
     - ContentViewTests.swift
   - Make sure "Bouncy Control Tests" target is checked
   - Click "Add"

6. **Configure test target settings**
   - Select the project in the Project Navigator
   - Select the "Bouncy Control Tests" target
   - Go to "Build Settings"
   - Search for "Enable Testability"
   - Ensure it's set to "Yes" for Debug configuration

7. **Link the main app target**
   - Select "Bouncy Control Tests" target
   - Go to "Build Phases"
   - Expand "Dependencies"
   - Click "+" and add "Bouncy Control" app target
   - This ensures tests can access the main app code

8. **Run the tests**
   - Press `⌘+U` to run all tests
   - Or use Test Navigator (`⌘+6`) to run specific tests

### Option 2: Manual Xcode Project File Editing (Advanced)

If you're comfortable editing `.pbxproj` files directly, you can add the test target manually. However, this is more error-prone and not recommended for most users.

## Verify Setup

After setup, verify everything works:

1. **Build the test target**
   ```bash
   xcodebuild build-for-testing \
     -project "Bouncy Control.xcodeproj" \
     -scheme "Bouncy Control" \
     -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

2. **Run tests**
   ```bash
   xcodebuild test \
     -project "Bouncy Control.xcodeproj" \
     -scheme "Bouncy Control" \
     -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

3. **Check test output**
   - You should see all tests passing
   - Total test count: 60+ tests
   - Execution time: < 10 seconds

## Common Issues

### "No such module 'Bouncy_Control'"

**Solution:**
1. Select the main "Bouncy Control" target
2. Go to Build Settings
3. Search for "Enable Testability"
4. Set to "Yes" for Debug configuration
5. Clean build folder (⌘+Shift+K)
6. Build again (⌘+B)

### "Target 'Bouncy Control Tests' not found"

**Solution:**
1. Make sure you created the test target in Xcode
2. Verify the target appears in the project's target list
3. Check that the scheme includes the test target

### Tests can't find app code

**Solution:**
1. Import using `@testable import Bouncy_Control`
2. Note: Use underscore, not space (Bouncy_Control not Bouncy Control)
3. Ensure "Enable Testability" is set to "Yes"
4. Verify the test target depends on the app target

### Build fails with "duplicate symbols"

**Solution:**
1. Check that test files are only included in test target
2. Main app files should NOT be in test target's "Compile Sources"
3. Only add files to test target that are specifically test files

## Test Target Configuration

### Recommended Build Settings

| Setting | Value | Description |
|---------|-------|-------------|
| Product Name | Bouncy Control Tests | Name of test bundle |
| Product Bundle ID | com.yourdomain.Bouncy-Control-Tests | Unique identifier |
| iOS Deployment Target | 17.0 | Match main app target |
| Enable Testability | Yes (Debug) | Allows @testable import |
| Swift Language Version | Swift 5 | Match main app |

### Info.plist Configuration

The Info.plist file has been created for you with these settings:
- Bundle Version: 1.0
- Bundle Identifier: Uses PRODUCT_BUNDLE_IDENTIFIER variable
- Package Type: BNDL (Bundle)

## Testing from Command Line

Once set up, you can run tests from the command line:

```bash
# Run all tests
xcodebuild test \
  -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Run specific test class
xcodebuild test \
  -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:Bouncy_Control_Tests/NetworkServiceTests

# Run specific test method
xcodebuild test \
  -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:Bouncy_Control_Tests/NetworkServiceTests/testSendCommand_WithInvalidURL_ThrowsError
```

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          xcodebuild test \
            -project "Bouncy Control.xcodeproj" \
            -scheme "Bouncy Control" \
            -destination 'platform=iOS Simulator,name=iPhone 16' \
            -enableCodeCoverage YES
```

### Xcode Cloud Configuration

1. Connect your repository to Xcode Cloud
2. Create a new workflow
3. Add "Test" action
4. Select "Bouncy Control" scheme
5. Choose iOS simulator destination
6. Save and run

## Next Steps

After setup:
1. ✅ Run all tests to ensure they pass
2. ✅ Review test coverage (see README.md)
3. ✅ Add tests for new features as you develop
4. ✅ Consider adding UI tests for user interactions
5. ✅ Set up CI/CD to run tests automatically

## Support

If you encounter issues:
1. Check the "Common Issues" section above
2. Review Xcode console for detailed error messages
3. Ensure all dependencies are properly configured
4. Try cleaning build folder (⌘+Shift+K) and rebuilding

## Resources

- [Apple's Testing Documentation](https://developer.apple.com/documentation/xctest)
- [Swift Testing Best Practices](https://developer.apple.com/videos/play/wwdc2019/413/)
- [XCTest Framework Reference](https://developer.apple.com/documentation/xctest)
