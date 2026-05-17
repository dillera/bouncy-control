# App Store Submission - Quick Start Guide

**For**: Bouncy Control v1.0.2
**Status**: Ready to prepare for submission

## 🎯 What You Have

Your app is **working and tested** on your iPhone SE 2! ✅

Now you need to:
1. Prepare App Store listing (metadata, screenshots)
2. Create distribution build
3. Upload to App Store Connect
4. Submit for review

## 📚 Documentation Overview

I've created comprehensive guides for you:

| File | Purpose | When to Use |
|------|---------|-------------|
| **APP_STORE_CHECKLIST.md** | Interactive checklist | ✅ START HERE - Follow step-by-step |
| **APP_STORE_DEPLOYMENT_GUIDE.md** | Detailed instructions | 📖 Reference for detailed info |
| **ExportOptions.plist** | Build configuration | 🔧 Used by build script |
| **create-app-store-build.sh** | Automated build script | 🚀 Creates archive automatically |

## 🚀 Getting Started (5 Steps)

### Step 1: Get Apple Developer Account Ready (15 min)

**If you have an active account:**
- [ ] Go to https://developer.apple.com
- [ ] Verify your membership is active
- [ ] Ensure 2FA is enabled

**If you need to enroll:**
- [ ] Go to https://developer.apple.com/programs/enroll/
- [ ] Cost: $99/year
- [ ] Processing time: Usually instant, can take 24-48 hours
- [ ] Need: Apple ID, credit card, business info (if company)

### Step 2: Create App in App Store Connect (30 min)

1. Go to https://appstoreconnect.apple.com
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - **Bundle ID**: `com.diller.Bouncy-Control` (already configured)
   - **App Name**: "Bouncy Control" (or your preferred name - check availability)
   - **Primary Language**: English
   - **SKU**: Any unique ID (e.g., "bouncy-control-001")

### Step 3: Prepare Assets (1-2 hours)

#### A. Screenshots (REQUIRED)
You need at least 3 screenshots for iPhone. Here's how:

```bash
# 1. Open Xcode and run on iPhone 16 Pro Max simulator
# 2. Navigate through your app screens
# 3. Press ⌘+S to save screenshots
# 4. Screenshots save to Desktop
```

**What to capture:**
- Main screen with servers
- Sending a message
- Server add/edit
- Quick actions

**Sizes needed:**
- iPhone 16 Pro Max: 1290 x 2796 pixels (minimum 3 screenshots)

#### B. Privacy Policy (REQUIRED)
Create a simple document covering:
- What data: Server URLs and names
- How stored: Locally on device only
- Sharing: No data shared with third parties
- User control: Users can delete servers anytime

**Host it**: GitHub Pages, your website, or privacy policy generator

#### C. App Description
Write compelling description highlighting:
- Control Bounce displays remotely
- Manage multiple servers
- Send custom messages
- Control display timing
- Simple, clean interface

See `APP_STORE_DEPLOYMENT_GUIDE.md` for example text

### Step 4: Create Distribution Build (15 min)

#### Option A: Using the Helper Script (Easiest!)

```bash
# In Terminal, from project directory:
./create-app-store-build.sh
```

This script will:
1. Clean your project
2. Create an archive
3. Export for App Store
4. Show you next steps

#### Option B: Using Xcode

1. Open project in Xcode
2. Product → Destination → "Any iOS Device (arm64)"
3. Product → Archive
4. Wait for completion
5. Organizer opens → Click "Distribute App" → "App Store Connect" → "Upload"

### Step 5: Submit for Review (30 min)

1. Go back to App Store Connect
2. Your app → Version 1.0.2
3. Fill in all required fields:
   - [ ] App Description
   - [ ] Keywords
   - [ ] Screenshots
   - [ ] Privacy Policy URL
   - [ ] Support URL
   - [ ] Select uploaded build
4. **Review Notes** (IMPORTANT):
```
This app controls Bounce display servers on local networks.
NSAppTransportSecurity allows HTTP connections to these servers.

For testing, you can add any server URL - the app will send
HTTP GET requests to the specified endpoints.

No login or authentication required.
```
5. Click "Submit for Review"

## ⏰ Timeline

- **Your prep work**: 2-4 hours
- **Apple's review**: 1-7 days (usually 24-48 hours)
- **Total**: ~1 week from start to App Store

## ⚠️ Common Issues & Solutions

### Issue: "I don't have Apple Distribution certificate"
**Solution**:
```
Xcode → Settings → Accounts → Your Apple ID
→ Manage Certificates → "+" → Apple Distribution
```

### Issue: "Archive button is greyed out"
**Solution**:
- Ensure destination is "Any iOS Device (arm64)" not Simulator
- Product → Destination → Any iOS Device

### Issue: "Build failed to upload"
**Solution**:
- Check your internet connection
- Verify Apple ID credentials in Xcode
- Try Transporter app as alternative

### Issue: "App Store Connect says 'Missing Compliance'"
**Solution**:
- Answer: "Does your app use encryption?" → NO
- Or add to Info.plist:
  ```xml
  <key>ITSAppUsesNonExemptEncryption</key>
  <false/>
  ```

## 🎯 What You Need Right Now

To get started TODAY:

1. ✅ **Verify Apple Developer membership is active**
   - Go to https://developer.apple.com
   - Check membership status

2. 📸 **Take 3 screenshots**
   - Open app in Xcode
   - Run on iPhone 16 Pro Max simulator
   - Capture 3 different screens (⌘+S)

3. 📝 **Create privacy policy**
   - Use a simple template online
   - Host on GitHub Pages or your website
   - Just needs to be accessible via URL

4. 📱 **Create app in App Store Connect**
   - https://appstoreconnect.apple.com
   - My Apps → + → New App
   - Fill in basic info

**Once you have these 4 things**, you can create the archive and submit!

## 📞 Need Help?

**Detailed Instructions**: See `APP_STORE_DEPLOYMENT_GUIDE.md`

**Step-by-Step Checklist**: See `APP_STORE_CHECKLIST.md`

**Apple Resources**:
- App Store Connect: https://appstoreconnect.apple.com
- Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Developer Forums: https://developer.apple.com/forums/

**Build Issues**: Run the helper script and check output:
```bash
./create-app-store-build.sh
```

## 🎉 You're Ready!

Your app is:
- ✅ Built and tested on device
- ✅ Code signed for development
- ✅ Working properly
- ✅ Has all necessary configuration

You just need to:
1. Prepare the App Store listing
2. Create the distribution build
3. Upload and submit

**Estimated time to submission**: 2-4 hours of focused work

**Follow the checklist** in `APP_STORE_CHECKLIST.md` and you'll be live in the App Store within a week!

Good luck! 🚀

---

**Quick Commands Reference**:

```bash
# Create App Store build
./create-app-store-build.sh

# Check signing identities
security find-identity -v -p codesigning

# Take screenshots in simulator
# Press ⌘+S while app is running

# Upload via command line (after export)
xcrun altool --upload-app \
  -f "./build/AppStore/Bouncy Control.ipa" \
  -t ios \
  -u "your-apple-id@email.com"
```
