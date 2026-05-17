# App Store Submission Checklist - Bouncy Control

Quick reference checklist for submitting to the App Store. See `APP_STORE_DEPLOYMENT_GUIDE.md` for detailed instructions.

## ✅ Pre-Submission (Complete Before Starting)

### Account Setup
- [ ] Active Apple Developer Account ($99/year)
- [ ] Two-factor authentication enabled
- [ ] Agreed to latest Developer Program License Agreement
- [ ] Verified account status at developer.apple.com

### Development Certificate
- [ ] Apple Development certificate installed (for testing) ✓
- [ ] Apple Distribution certificate installed (for App Store)
  - Check in: Xcode → Settings → Accounts → Manage Certificates
  - Should see "Apple Distribution: [Your Name]"

## 📱 App Store Connect Setup

### Create App Record
- [ ] Logged into appstoreconnect.apple.com
- [ ] Created new app
- [ ] Bundle ID: `com.diller.Bouncy-Control`
- [ ] App Name: "Bouncy Control" (or your preferred name)
- [ ] SKU: Created unique identifier
- [ ] Primary Language: English

### App Information
- [ ] **Name**: _________________________
- [ ] **Subtitle**: _______________________ (30 char max)
- [ ] **Category**:
  - Primary: Utilities ☐ or Simulation Games ☐
  - Secondary: Productivity ☐ or Entertainment ☐
- [ ] **Age Rating**: Completed questionnaire

### Pricing
- [ ] Price: Free ☐ or Paid ☐ $_________
- [ ] Availability: All territories ☐ or Selected ☐
- [ ] Pre-Order: Yes ☐ No ☐

## 📝 Content Requirements

### Privacy Policy (REQUIRED)
- [ ] Created privacy policy document
- [ ] Hosted online (URL): _________________________
- [ ] Added URL to App Store Connect
- [ ] Covers: data collection, storage, user rights

### Privacy Labels (Answer in App Store Connect)
- [ ] Data Collection: User Content (server URLs)
- [ ] Data Linked to User: NO
- [ ] Data Used for Tracking: NO

### App Description
- [ ] Written compelling description (4000 char max)
- [ ] Highlights key features
- [ ] Clear value proposition
- [ ] No marketing fluff or excessive caps/emoji

### Keywords
- [ ] Researched relevant keywords
- [ ] Added to App Store Connect (100 char max)
- [ ] Example: bounce,display,signage,remote,control,broadcast,server,message

### URLs
- [ ] Support URL: _________________________
- [ ] Marketing URL (optional): _________________________

### Promotional Text (optional, can update anytime)
- [ ] Written (170 char max)
- [ ] Highlights current features/updates

## 📸 Screenshots (REQUIRED)

### iPhone (At least 3 screenshots for ONE size required)
- [ ] **6.9" Display (iPhone 16 Pro Max)**: 1290 x 2796 px
  - [ ] Screenshot 1: _______________
  - [ ] Screenshot 2: _______________
  - [ ] Screenshot 3: _______________
- [ ] 6.7" Display (iPhone 14 Pro Max): 1290 x 2796 px (optional)
- [ ] 6.5" Display (iPhone 11 Pro Max): 1284 x 2778 px (optional)
- [ ] 5.5" Display (iPhone 8 Plus): 1242 x 2208 px (optional)

### iPad (Optional but recommended for universal apps)
- [ ] 12.9" Display (iPad Pro): 2048 x 2732 px
  - [ ] Screenshot 1: _______________
  - [ ] Screenshot 2: _______________

### Screenshot Content Ideas:
- [ ] Main screen with server list
- [ ] Control view sending message
- [ ] Server add/edit screen
- [ ] Quick actions panel

### How to Create:
```bash
# Use simulator
1. Open app in Xcode
2. Run on iPhone 16 Pro Max simulator
3. Navigate to each screen
4. Press ⌘+S to save screenshot
5. Screenshots saved to Desktop
```

## 🎨 App Icon

### Current Status
- [x] Icon exists: `bcontrol.png` in Assets.xcassets
- [ ] Verified 1024x1024 pixels
- [ ] High quality (no blurriness)
- [ ] No transparency
- [ ] No rounded corners (iOS adds them)
- [ ] Looks good at small sizes

### Verify Icon:
```bash
# Check icon size
sips -g pixelWidth -g pixelHeight "Bouncy Control/Assets.xcassets/AppIcon.appiconset/bcontrol.png"
# Should show: 1024 x 1024
```

## 🔐 Code Signing

### Check Current Status
```bash
# List signing identities
security find-identity -v -p codesigning
```

### Required:
- [x] Apple Development: _________ (TEAMID: YBX2V97SYB) ✓
- [ ] Apple Distribution: _________ (TEAMID: YBX2V97SYB)

### If Missing Distribution Certificate:
1. Xcode → Settings → Accounts
2. Select Apple ID
3. "Manage Certificates" → "+" → "Apple Distribution"

### Xcode Signing Settings
- [ ] Open project in Xcode
- [ ] Select "Bouncy Control" target
- [ ] "Signing & Capabilities" tab
- [ ] "Automatically manage signing" ☑ (recommended)
- [ ] Team: YBX2V97SYB selected
- [ ] Release configuration will use Distribution certificate

## 📋 App Store Review Information

### Demo Account
- [ ] Does app require login? NO ✓
- [ ] Demo server URL provided: _________________________

### Review Notes (IMPORTANT)
- [ ] Explained NSAppTransportSecurity usage
- [ ] Provided testing instructions
- [ ] Included demo server URL (if available)

Example notes:
```
This app controls Bounce display servers on local networks,
which often use HTTP without HTTPS. NSAppTransportSecurity
allows these connections.

Test server: http://[YOUR_SERVER]:8080
No authentication required.
```

### Contact Information
- [ ] First Name: _________________________
- [ ] Last Name: _________________________
- [ ] Phone: _________________________
- [ ] Email: _________________________

## 🏗️ Build & Archive

### Pre-Build Checklist
- [ ] All code changes committed to git
- [ ] Version number updated (currently: 1.0.2)
- [ ] Build number updated (currently: 1.2)
- [ ] Tested on physical device
- [ ] No warnings in build
- [ ] All features working

### Update Version (if needed)
```bash
# In Xcode:
# Project → Bouncy Control target → General
# Version: 1.0.2 → 1.0.3 (for updates)
# Build: 1.2 → 1.3
```

### Create Archive - Method 1: Xcode (Recommended)

- [ ] Product → Destination → "Any iOS Device (arm64)"
- [ ] Product → Scheme → Edit Scheme → Run → Release
- [ ] Product → Clean Build Folder (⌘⇧K)
- [ ] Product → Archive
- [ ] Wait for archive to complete
- [ ] Organizer window opens automatically

### Create Archive - Method 2: Command Line

```bash
# Clean
xcodebuild clean -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" -configuration Release

# Archive
xcodebuild archive \
  -project "Bouncy Control.xcodeproj" \
  -scheme "Bouncy Control" \
  -configuration Release \
  -archivePath "./build/Bouncy Control.xcarchive" \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM=YBX2V97SYB
```

- [ ] Archive created successfully
- [ ] No build errors
- [ ] Archive appears in Organizer (Xcode → Window → Organizer)

## 📤 Upload to App Store

### Method 1: Xcode Organizer (Easiest)
- [ ] Organizer → Archives → Select "Bouncy Control"
- [ ] Click "Distribute App"
- [ ] Select "App Store Connect"
- [ ] Click "Upload"
- [ ] Select "Automatically manage signing"
- [ ] Review summary
- [ ] Click "Upload"
- [ ] Wait for upload (shows progress)
- [ ] Success confirmation

### Method 2: Transporter App
- [ ] Export archive to .ipa file
- [ ] Open Transporter app
- [ ] Drag .ipa file to Transporter
- [ ] Click "Deliver"

### Method 3: Command Line
```bash
# Export archive
xcodebuild -exportArchive \
  -archivePath "./build/Bouncy Control.xcarchive" \
  -exportPath "./build/AppStore" \
  -exportOptionsPlist ExportOptions.plist

# Upload
xcrun altool --upload-app \
  -f "./build/AppStore/Bouncy Control.ipa" \
  -t ios \
  -u "your-apple-id@email.com" \
  -p "@keychain:AC_PASSWORD"
```

## 🚀 Submit for Review

### Wait for Processing
- [ ] Wait 5-15 minutes after upload
- [ ] Refresh App Store Connect
- [ ] Build appears under "Build" section
- [ ] Build shows "Processing" → "Ready to Submit"

### Final Checks in App Store Connect
- [ ] App Information: Complete ✓
- [ ] Pricing and Availability: Set ✓
- [ ] App Privacy: Completed ✓
- [ ] Screenshots: Uploaded ✓
- [ ] App Description: Written ✓
- [ ] Keywords: Added ✓
- [ ] Support URL: Added ✓
- [ ] Build: Selected ✓

### Export Compliance
- [ ] Question: "Does your app use encryption?"
- [ ] Answer: NO (unless using HTTPS only)

### Add to Version
- [ ] Click "+ Build"
- [ ] Select your uploaded build
- [ ] Click "Done"

### Final Review
- [ ] Review all information one last time
- [ ] Check for typos
- [ ] Verify screenshots display correctly
- [ ] Ensure all required fields filled

### Submit!
- [ ] Click "Add for Review" or "Submit for Review"
- [ ] Confirm submission
- [ ] Status changes to "Waiting for Review"

## ⏳ After Submission

### Review Status
- [ ] "Waiting for Review" - In queue (typically 24-48 hours)
- [ ] "In Review" - Being reviewed (a few hours)
- [ ] "Pending Developer Release" or "Ready for Sale" - APPROVED! 🎉
- [ ] "Rejected" - Review feedback provided

### If Approved
- [ ] App automatically goes live (or manual release if you chose that)
- [ ] Appears in App Store within 24 hours
- [ ] Send to friends/colleagues
- [ ] Monitor reviews and ratings
- [ ] Respond to user feedback

### If Rejected
- [ ] Read rejection reason carefully
- [ ] Address all issues mentioned
- [ ] Make necessary changes
- [ ] Re-submit (no need to create new build unless code changes)

## 📊 Common Rejection Reasons

1. **Missing Privacy Policy**
   - [ ] Ensure URL is valid and accessible

2. **Crashes or Bugs**
   - [ ] Test thoroughly before submission
   - [ ] Include testing notes for reviewer

3. **Incomplete Information**
   - [ ] Fill ALL required fields
   - [ ] Double-check App Store Connect

4. **NSAppTransportSecurity Without Explanation**
   - [ ] Explain in review notes why HTTP is needed
   - [ ] Mention local network servers

5. **Misleading Description/Screenshots**
   - [ ] Ensure accurate representation of app
   - [ ] No fake features or functionality

## 📈 Post-Approval Tasks

### Marketing
- [ ] Create social media posts
- [ ] Update website with App Store link
- [ ] Add App Store badge to documentation
- [ ] Share with relevant communities

### Monitoring
- [ ] Check App Store Connect analytics
- [ ] Monitor crash reports
- [ ] Read user reviews
- [ ] Track downloads

### Updates
- [ ] Plan future features
- [ ] Fix bugs reported by users
- [ ] Submit updates regularly
- [ ] Respond to reviews

## 🆘 Troubleshooting

### "No accounts with App Store Connect access"
- [ ] Verify Apple Developer membership is active
- [ ] Sign in to Xcode with correct Apple ID
- [ ] Check account status at developer.apple.com

### "Provisioning profile error"
- [ ] Xcode → Settings → Accounts → Download Manual Profiles
- [ ] Or use automatic signing (recommended)

### "Archive not appearing in Organizer"
- [ ] Ensure destination is "Any iOS Device", not simulator
- [ ] Clean build folder and try again
- [ ] Check scheme is set to Release

### "Code signing failed"
- [ ] Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- [ ] Restart Xcode
- [ ] Product → Clean Build Folder
- [ ] Try archiving again

## 📞 Getting Help

- **Apple Developer Forums**: https://developer.apple.com/forums/
- **App Store Connect Help**: https://help.apple.com/app-store-connect/
- **Developer Support**: https://developer.apple.com/support/
- **Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/

---

## ⏱️ Time Estimate

- **Setup & Preparation**: 2-3 hours
- **Screenshots & Assets**: 1-2 hours
- **Archive & Upload**: 15-30 minutes
- **Review Process**: 1-7 days

**Total**: ~4-5 hours + review time

---

**Remember**: Don't rush! Take time to ensure everything is correct before submission.

**Ready?** Start with Section 1 (Pre-Submission) and work your way down!

Good luck! 🚀
