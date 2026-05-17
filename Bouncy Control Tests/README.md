# Bouncy Control Tests

This directory contains the unit test suite for the Bouncy Control iOS application.

## Test Structure

### NetworkServiceTests.swift
Tests for the `NetworkService` class that handles all network communication.

**Coverage:**
- URL validation (HTTP/HTTPS protocols)
- Error handling for invalid URLs
- Broadcast message validation
- Display time validation
- Network error descriptions
- Edge cases (empty messages, zero/negative display times)

**Key Test Cases:**
- `testSendCommand_WithInvalidURL_ThrowsError()` - Validates URL format checking
- `testSendBroadcast_WithEmptyMessage_ThrowsError()` - Ensures messages aren't empty
- `testSendBroadcast_WithZeroDisplayTime_ThrowsError()` - Validates display time > 0
- `testNetworkError_*_Description()` - Tests error message formatting

### ControlViewModelTests.swift
Tests for the `ControlViewModel` that manages the control view state and business logic.

**Coverage:**
- Initial state verification
- Display time validation
- Loading state management
- Error handling
- Message clearing behavior
- Published property updates

**Key Test Cases:**
- `testInitialState()` - Verifies default values
- `testSendBroadcast_WithInvalidDisplayTime_ShowsError()` - Input validation
- `testSendCommand_SetsLoadingState()` - Loading indicator behavior
- `testMessageProperty_IsPublished()` - Combine publisher verification

### ServerTests.swift
Tests for the `Server` model that represents a Bouncy server configuration.

**Coverage:**
- Model initialization
- Identifiable conformance (unique IDs)
- Codable conformance (JSON encoding/decoding)
- Property mutation
- URL format handling
- Edge cases (empty values, special characters)

**Key Test Cases:**
- `testServerHasUniqueIDs()` - Ensures each server has unique identifier
- `testServerRoundTripEncoding()` - Validates JSON serialization
- `testServerArrayEncodingDecoding()` - Tests array persistence
- `testServerPropertiesAreMutable()` - Confirms struct mutability

### ContentViewTests.swift
Tests for ContentView business logic (not UI rendering).

**Coverage:**
- Server list management (add, update, delete)
- JSON persistence
- Input validation and trimming
- Server lookup by ID
- Edge cases (duplicate names, large lists)

**Key Test Cases:**
- `testServerListAppending()` - Adding servers to list
- `testServerUpdate()` - Updating existing servers
- `testServerArrayEncoding()` - Data persistence format
- `testFindServerByID()` - Server retrieval logic

## Running Tests

### From Xcode
1. Open `Bouncy Control.xcodeproj`
2. Select the test scheme
3. Press `⌘+U` to run all tests
4. Or use `⌘+6` to open the Test Navigator and run specific tests

### From Command Line
```bash
# Run all tests
xcodebuild test -project "Bouncy Control.xcodeproj" -scheme "Bouncy Control" -destination 'platform=iOS Simulator,name=iPhone 16'

# Using Claude Code
/test-all
```

### From Claude Code MCP
```swift
// Run all tests on simulator
mcp__xcodebuild__test_sim({
    projectPath: "/Users/dillera/code/Bouncy Control/Bouncy Control.xcodeproj",
    scheme: "Bouncy Control",
    simulatorName: "iPhone 16"
})
```

## Test Coverage

The test suite currently covers:
- ✅ Network layer (NetworkService)
- ✅ View models (ControlViewModel)
- ✅ Data models (Server)
- ✅ Business logic (ContentView logic)
- ⚠️ UI components (not tested - requires UI testing framework)

## Testing Best Practices

1. **Naming Convention**: Tests follow the pattern `test[MethodName]_[Scenario]_[ExpectedResult]()`
2. **AAA Pattern**: Tests use Arrange-Act-Assert structure with Given-When-Then comments
3. **Isolation**: Each test is independent and doesn't rely on other tests
4. **Async Testing**: Async/await tests use `Task.sleep()` for timing-sensitive operations
5. **Mock Data**: Tests use local data and don't make real network calls

## Adding New Tests

When adding new features to Bouncy Control:

1. Create test file with naming: `[FeatureName]Tests.swift`
2. Import XCTest and `@testable import Bouncy_Control`
3. Follow existing test structure and naming conventions
4. Add documentation to this README
5. Ensure tests run in isolation (use `setUp()` and `tearDown()`)

## Known Limitations

- Network tests don't actually connect to servers (by design)
- Some async timing tests may be flaky on slow machines
- UI rendering is not tested (would require UI test target)
- Integration tests with real servers are not included

## CI/CD Integration

These tests are designed to run in continuous integration environments:
- All tests are deterministic and don't rely on external services
- Tests complete quickly (< 30 seconds total)
- No special configuration or credentials required
- Compatible with Xcode Cloud, GitHub Actions, and other CI systems

## Test Statistics

Last updated: 2025-10-22

- Total Test Files: 4
- Total Test Cases: ~60+
- Test Execution Time: < 10 seconds
- Code Coverage: ~80% (estimated, excluding UI)

## Troubleshooting

### Tests fail with "Module not found"
- Ensure the test target has access to the main app target
- Check build settings: `@testable import` requires `Enable Testability = YES`

### Async tests are flaky
- Increase `Task.sleep()` duration for slower machines
- Consider using XCTest expectations for better async handling

### Tests pass locally but fail in CI
- Check simulator availability in CI environment
- Verify Xcode version compatibility
- Ensure all dependencies are properly installed

## Future Enhancements

Planned test improvements:
- [ ] UI Tests target for end-to-end testing
- [ ] Mock URLSession for more controlled network testing
- [ ] Performance tests for large server lists
- [ ] Snapshot tests for UI consistency
- [ ] Integration tests with test server

## Contributing

When adding tests:
1. Follow existing naming and structure conventions
2. Add documentation for new test files
3. Update test statistics
4. Ensure all tests pass before committing
5. Consider edge cases and error scenarios
