# App Store Deployment Guide - Bouncy Control

Complete guide to submit your Bouncy Control app to the Apple App Store.

## Current Configuration Status

Based on your project analysis:

✅ **Working**:
- Bundle ID: `com.diller.Bouncy-Control`
- Development Team: `YBX2V97SYB`
- Version: 1.0.2 (Build 1.2)
- Code Signing: Automatic (Apple Development)
- iOS Deployment Target: 18.0
- Supported Devices: iPhone & iPad (Universal)

⚠️ **Needs Attention**:
- NSAppTransportSecurity allows arbitrary loads (required for HTTP servers)
- App category: simulation-games (should this be utilities?)
- Missing App Store assets (screenshots, preview video)
- Code signing configured for Development (needs Distribution)

## Pre-Submission Checklist

### 1. Apple Developer Account Setup

- [ ] Have an active Apple Developer Account ($99/year)
- [ ] Account in good standing with no violations
- [ ] Two-factor authentication enabled
- [ ] Agree to latest Developer Program License Agreement

**Action**: Visit [developer.apple.com](https://developer.apple.com) to verify/enroll

### 2. App Store Connect Setup

1. **Create App Record**
   - [ ] Go to [App Store Connect](https://appstoreconnect.apple.com)
   - [ ] Click "My Apps" → "+" → "New App"
   - [ ] Select iOS platform
   - [ ] Enter Bundle ID: `com.diller.Bouncy-Control`
   - [ ] Enter App Name: "Bouncy Control"
   - [ ] Select Primary Language: English
   - [ ] Select SKU (unique identifier, e.g., "bouncy-control-001")

2. **App Information**
   - [ ] **Name**: Bouncy Control (must be unique on App Store)
   - [ ] **Subtitle**: (max 30 chars, e.g., "Remote Control for Bounce Displays")
   - [ ] **Category**:
     - Primary: Utilities (recommended) or Games > Simulation
     - Secondary: Productivity or Entertainment
   - [ ] **Content Rights**: Does your app contain third-party content? NO
   - [ ] **Age Rating**: Complete questionnaire (likely 4+)

3. **Pricing and Availability**
   - [ ] Price: Free or Paid
   - [ ] Availability: All territories or specific countries
   - [ ] Pre-Order: Enable if desired

### 3. App Privacy Policy (REQUIRED)

Apple requires a privacy policy URL. Create one covering:
- What data you collect (server URLs, names)
- How data is stored (locally on device via @AppStorage)
- No data transmitted to third parties
- User control over data (can delete servers)

**Action**:
1. Create a simple privacy policy (can use templates online)
2. Host on GitHub Pages, your website, or use a generator
3. Add URL to App Store Connect

**Privacy Labels** (answer in App Store Connect):
- [ ] Data Collection: Contact Info? NO
- [ ] Data Collection: User Content? YES (server URLs - stored locally)
- [ ] Data Linked to User? NO
- [ ] Data Used for Tracking? NO

### 4. App Description & Metadata

**App Description** (4000 char max):
```
Bouncy Control is a simple, elegant remote control for your Bounce display servers.

FEATURES:
• Manage multiple Bounce servers
• Send custom broadcast messages
• Control display timing
• Quick-action commands (clear, off, on)
• Clean, intuitive interface
• Instant message preview

PERFECT FOR:
• Digital signage control
• Display management
• Office communication boards
• Event displays
• Retail environments

HOW IT WORKS:
1. Add your Bounce server URL
2. Send custom messages to all displays
3. Control display timing (1-999 seconds)
4. Use quick actions for common commands

No account required. All data stays on your device.
```

**Keywords** (100 char max, comma-separated):
```
bounce,display,signage,remote,control,broadcast,server,message,digital,screens
```

**Support URL**: Your website or GitHub repo
**Marketing URL**: Optional - your company website

**Promotional Text** (170 char, can update without review):
```
Control your Bounce displays from anywhere! Send messages, manage servers, and control display timing with this simple, powerful app.
```

### 5. Required Screenshots

You need screenshots for EACH device size:

**iPhone** (required):
- 6.9" Display (iPhone 16 Pro Max): 1290 x 2796 pixels (3 screenshots minimum)
- 6.7" Display (iPhone 14 Pro Max): 1290 x 2796 pixels
- 6.5" Display (iPhone 11 Pro Max): 1284 x 2778 pixels
- 5.5" Display (iPhone 8 Plus): 1242 x 2208 pixels

**iPad** (optional but recommended):
- 13" Display (iPad Pro): 2048 x 2732 pixels
- 12.9" Display: 2048 x 2732 pixels

**How to create**:
1. Run app on various simulator sizes
2. Take screenshots (⌘+S in simulator)
3. Or use Xcode's screenshot tool
4. Consider adding frames/captions for polish

**What to show**:
1. Main screen (server list)
2. Control screen (sending message)
3. Server management (add/edit)
4. Quick actions in use

### 6. App Icon Requirements

**Current Status**: You have `bcontrol.png` in AppIcon.appiconset

**Required Sizes** (all must be 1024x1024 for App Store):
- [ ] 1024x1024 pixels (App Store icon)
- App generates other sizes automatically from this

**Action**:
1. Ensure your icon is exactly 1024x1024
2. No transparency, no rounded corners (iOS adds them)
3. High quality PNG
4. Represents your app clearly at small sizes

### 7. App Store Review Information

Information for Apple's review team:

**Demo Account**:
- [ ] Does your app require login? NO
- [ ] Provide demo Bounce server for testing (recommended)

**Review Notes**:
```
This app is a remote control for Bounce digital display servers.

TESTING INSTRUCTIONS:
1. Add a test server (you can provide a demo URL)
2. The app allows arbitrary HTTP loads (NSAppTransportSecurity) because
   many Bounce servers run on local networks without HTTPS
3. Server URLs and names are stored locally on device only

No account or authentication required.

Demo server URL (if you have one): http://your-test-server.com:8080
```

**Contact Information**:
- [ ] First Name
- [ ] Last Name
- [ ] Phone Number
- [ ] Email Address

### 8. Code Signing for Distribution

**Current**: Using "Apple Development" (for testing)
**Needed**: "Apple Distribution" (for App Store)

#### In Xcode:

1. **Select Project** → Bouncy Control target
2. **Signing & Capabilities** tab
3. **Automatic Signing** (recommended):
   - Keep "Automatically manage signing" checked
   - Team: Your team (YBX2V97SYB)
   - For "Release" configuration, Xcode will use Distribution certificate

4. **Manual Signing** (advanced):
   - Uncheck "Automatically manage signing"
   - Provisioning Profile: Select App Store profile
   - Signing Certificate: Apple Distribution

#### Verify Certificates:

```bash
# List signing identities
security find-identity -v -p codesigning

# Should show:
# 1) Apple Development: Your Name (TEAMID)
# 2) Apple Distribution: Your Name (TEAMID)
```

If missing "Apple Distribution":
1. Xcode → Settings → Accounts
2. Select your Apple ID
3. Click "Manage Certificates"
4. Click "+" → "Apple Distribution"

### 9. Build Configuration

#### Update Info.plist (if needed):

Your current Info.plist has:
- `NSAllowsArbitraryLoads = true` - OKAY (needed for HTTP)
- `CFBundleDocumentTypes` - Consider removing if not needed

#### App Category:

Your current: `public.app-category.simulation-games`

**Recommendation**: Change to Utilities
```
INFOPLIST_KEY_LSApplicationCategoryType = public.app-category.utilities
```

Or keep as Games if you prefer that store category.

### 10. Create Archive

#### Method 1: Using Xcode (Recommended)

1. **Select Device**:
   - Product → Destination → "Any iOS Device (arm64)"
   - Do NOT use simulator

2. **Set Scheme to Release**:
   - Product → Scheme → Edit Scheme
   - Run → Build Configuration → Release

3. **Create Archive**:
   - Product → Archive
   - Wait for build to complete (may take 1-2 minutes)

4. **Organizer Opens**:
   - Select your archive
   - Click "Distribute App"
   - Choose "App Store Connect"
   - Click "Upload"
   - Select "Automatically manage signing"
   - Click "Upload"

#### Method 2: Using Command Line

```bash
# Clean build folder
xcodebuild clean -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" -configuration Release

# Create archive
xcodebuild archive \
  -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -configuration Release \
  -archivePath "./build/Bouncy Control.xcarchive" \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM=YBX2V97SYB

# Export for App Store
xcodebuild -exportArchive \
  -archivePath "./build/Bouncy Control.xcarchive" \
  -exportPath "./build/AppStore" \
  -exportOptionsPlist ExportOptions.plist
```

**ExportOptions.plist** (create this file):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YBX2V97SYB</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

### 11. Upload to App Store Connect

#### Using Xcode (Easiest):
- After creating archive, Xcode Organizer will show it
- Click "Distribute App" → "App Store Connect" → "Upload"

#### Using Application Loader / Transporter:
1. Download "Transporter" app from Mac App Store
2. Drag exported .ipa file to Transporter
3. Click "Deliver"

#### Using altool (command line):
```bash
xcrun altool --upload-app \
  -f "./build/AppStore/Bouncy Control.ipa" \
  -t ios \
  -u "your-apple-id@email.com" \
  -p "@keychain:AC_PASSWORD"
```

### 12. Submit for Review

1. **Go to App Store Connect**
2. **My Apps** → **Bouncy Control**
3. **Select Build**:
   - Wait ~5 minutes for build to process after upload
   - Click "+ Build" under "Build" section
   - Select your uploaded build

4. **Complete All Sections**:
   - [ ] App Information (name, category, etc.)
   - [ ] Pricing and Availability
   - [ ] App Privacy
   - [ ] Screenshots
   - [ ] App Description
   - [ ] Keywords
   - [ ] Support URL
   - [ ] Version Information

5. **Export Compliance**:
   - Does your app use encryption?
   - Answer: NO (unless you add HTTPS features)

6. **Content Rights**:
   - Does your app contain third-party content? NO

7. **Advertising Identifier**:
   - Does your app use IDFA? NO

8. **Click "Submit for Review"**

### 13. Review Process

**Timeline**: Usually 24-48 hours, can be up to 7 days

**Common Rejection Reasons** (and how to avoid):

1. **Missing Privacy Policy**
   - ✅ Include URL before submission

2. **Crashes on Launch**
   - ✅ Test thoroughly on physical device
   - ✅ Test on various iOS versions

3. **Incomplete Information**
   - ✅ Fill out ALL required fields in App Store Connect

4. **NSAppTransportSecurity**
   - ✅ Explain in review notes why HTTP is needed
   - ✅ Note: Local network servers may not have HTTPS

5. **Demo Account/Content**
   - ✅ Provide demo server URL for reviewer testing

**Review Notes to Include**:
```
This app controls Bounce display servers, which often run on local
networks without HTTPS certificates. NSAppTransportSecurity is
required for HTTP connections to these local servers.

Test server available at: [YOUR_TEST_URL]
No authentication required - just add the server URL and send a test message.
```

### 14. After Approval

- **App Status**: "Ready for Sale"
- **Release Options**:
  - Automatic: Goes live immediately after approval
  - Manual: You choose when to release

- **Updates**:
  - Increment version number (MARKETING_VERSION)
  - Increment build number (CURRENT_PROJECT_VERSION)
  - Submit same process

## Common Issues & Solutions

### Issue: "No accounts with App Store Connect access"
**Solution**: Ensure Apple Developer membership is active and you're signed in to Xcode

### Issue: "Provisioning profile doesn't include signing certificate"
**Solution**: In Xcode → Settings → Accounts, download manual profiles

### Issue: "Failed to code sign"
**Solution**:
1. Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
2. Restart Xcode
3. Product → Clean Build Folder

### Issue: "Archive doesn't appear in Organizer"
**Solution**: Ensure you selected "Any iOS Device (arm64)", not Simulator

### Issue: "App uses non-exempt encryption"
**Solution**: Add to Info.plist:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

## Quick Command Reference

```bash
# View current signing identity
security find-identity -v -p codesigning

# Clean project
xcodebuild clean -project "Bouncy Control.xcodeproj"

# Build for device (testing)
xcodebuild build -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -configuration Debug \
  -destination 'generic/platform=iOS'

# Create archive
xcodebuild archive -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -archivePath "./build/App.xcarchive"

# Validate archive
xcodebuild -exportArchive \
  -archivePath "./build/App.xcarchive" \
  -exportPath "./build/" \
  -exportOptionsPlist ExportOptions.plist
```

## Resources

- **App Store Connect**: https://appstoreconnect.apple.com
- **Developer Portal**: https://developer.apple.com/account
- **App Store Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
- **App Store Connect Help**: https://help.apple.com/app-store-connect/

## Timeline Estimate

| Task | Time Estimate |
|------|--------------|
| Create App Store Connect record | 15 minutes |
| Write app description & metadata | 30 minutes |
| Create screenshots | 1-2 hours |
| Privacy policy | 30 minutes |
| Archive & upload | 15 minutes |
| Review process | 1-7 days |
| **Total** | **~3-4 hours + review time** |

## Next Steps

1. ✅ Read this guide thoroughly
2. ⏭️ Create App Store Connect record
3. ⏭️ Prepare screenshots and assets
4. ⏭️ Write privacy policy
5. ⏭️ Create archive and upload
6. ⏭️ Submit for review

---

**Questions?** Common issues are covered above. For specific problems, check Apple's developer forums or documentation.

**Ready to deploy?** Let's start with creating the archive!
