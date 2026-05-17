# App Store Screenshot Guide - Bouncy Control

## ✅ Current Status

Your app is **running** on iPhone 16 Pro Max simulator (iOS 18.2)!

The simulator should be visible on your screen. If not:
- Look for "Simulator" app in your Dock or open windows
- Or: Open Spotlight (⌘+Space) → type "Simulator" → Enter

## 📸 Required Screenshots

You need **minimum 3 screenshots** for App Store submission.

### Dimensions Required
- **iPhone 16 Pro Max**: 1290 x 2796 pixels
- Format: PNG
- Status bar: Show (default - includes time, battery, etc.)

## 🎯 Screenshot Plan

I recommend these 4 screenshots to showcase your app:

### Screenshot 1: Welcome/Main Screen
**Shows**: Clean interface with "Add Server" functionality
**Purpose**: First impression - shows what the app does
**Captures**: App icon, add server button, empty state or server list

### Screenshot 2: Server List with Servers
**Shows**: List of servers (add 2-3 demo servers first)
**Purpose**: Shows server management capability
**Captures**: Multiple servers, edit/delete options, navigation

### Screenshot 3: Control View
**Shows**: The control interface for sending messages
**Purpose**: Main functionality - sending commands
**Captures**: Message input, display time, command buttons

### Screenshot 4: Sending a Broadcast
**Shows**: Broadcast message being composed
**Purpose**: Key feature - broadcasting to displays
**Captures**: Message text field, time selector, send button

## 📋 Step-by-Step Instructions

### Preparation (Do This First)

1. **Check Simulator is Visible**
   - Look for iPhone 16 Pro Max simulator window
   - Should show your Bouncy Control app running

2. **Add Demo Servers** (for better screenshots)
   - In the app, click "Save Server" button
   - Add these demo servers:
     ```
     Name: Office Display
     URL: http://office.local:8080

     Name: Reception Screen
     URL: http://192.168.1.100:8080

     Name: Main Lobby
     URL: http://lobby.example.com:8080
     ```

3. **Navigate to Different Screens**
   - Tap on a server to see control view
   - Try entering a message
   - Explore all screens you want to capture

### Taking Screenshots (3 Methods)

#### Method 1: Keyboard Shortcut (Easiest!)

1. **Make sure simulator is focused** (click on simulator window)
2. **Navigate to the screen you want to capture**
3. **Press: ⌘+S** (Command + S)
4. **Screenshot saved to Desktop** as PNG file

#### Method 2: Simulator Menu

1. Click on **Simulator** app menu bar
2. Select **File** → **Save Screen**
3. Choose location (default: Desktop)
4. Click "Save"

#### Method 3: macOS Screenshot Tool

1. **Press: ⌘+Shift+4** (Command + Shift + 4)
2. **Press: Spacebar** (turns cursor into camera icon)
3. **Click on Simulator window**
4. Screenshot saved to Desktop

**Recommendation**: Use Method 1 (⌘+S) - fastest and most reliable!

### Screenshot Checklist

Use this checklist as you capture:

- [ ] **Screenshot 1**: Main screen/server list
  - Shows app interface clearly
  - Good lighting (not too dark)
  - Status bar visible

- [ ] **Screenshot 2**: Control view
  - Server selected
  - Control buttons visible
  - Clear what user can do

- [ ] **Screenshot 3**: Broadcast message
  - Message being composed
  - Display time visible
  - Shows key functionality

- [ ] **(Optional) Screenshot 4**: Server management
  - Add/Edit server screen
  - Shows configuration options

## 🎨 Screenshot Tips

### DO:
✅ Use default iOS status bar (shows time, battery, signal)
✅ Keep simulator at 100% scale (not zoomed)
✅ Capture clean, uncluttered screens
✅ Show actual functionality
✅ Use realistic demo data (not "test test test")

### DON'T:
❌ Don't add your own status bar mockups
❌ Don't remove status bar
❌ Don't edit/crop the screenshots
❌ Don't add text overlays yet (optional later)
❌ Don't use fake/Lorem Ipsum data if possible

## 📁 After Capturing

### 1. Locate Your Screenshots

Screenshots are saved to your **Desktop** by default with names like:
```
Screenshot 2025-10-22 at 12.47.30 PM.png
Screenshot 2025-10-22 at 12.48.15 PM.png
Screenshot 2025-10-22 at 12.49.02 PM.png
```

### 2. Verify Dimensions

Run this command to check sizes:
```bash
cd ~/Desktop
for f in Screenshot*.png; do
  sips -g pixelWidth -g pixelHeight "$f"
done
```

**Should show**: 1290 x 2796 for each screenshot

If wrong size, check:
- Are you using iPhone 16 Pro Max simulator?
- Is simulator at 100% scale? (Window → Scale → 100%)

### 3. Rename for Organization

I recommend renaming to:
```bash
cd ~/Desktop
mv "Screenshot 2025-10-22 at 12.47.30 PM.png" "bouncy-control-01-main.png"
mv "Screenshot 2025-10-22 at 12.48.15 PM.png" "bouncy-control-02-control.png"
mv "Screenshot 2025-10-22 at 12.49.02 PM.png" "bouncy-control-03-broadcast.png"
```

### 4. Create a Screenshots Folder

```bash
mkdir -p ~/Desktop/Bouncy\ Control\ Screenshots
mv bouncy-control-*.png ~/Desktop/Bouncy\ Control\ Screenshots/
```

## 🎬 Quick Reference Commands

```bash
# Check screenshot dimensions
sips -g pixelWidth -g pixelHeight ~/Desktop/Screenshot*.png

# Verify all are 1290x2796
ls -lh ~/Desktop/Screenshot*.png

# Create organized folder
mkdir -p ~/Desktop/Bouncy\ Control\ Screenshots
mv ~/Desktop/Screenshot*.png ~/Desktop/Bouncy\ Control\ Screenshots/

# Rename screenshots
cd ~/Desktop/Bouncy\ Control\ Screenshots
mv "Screenshot 2025-10-22 at 12.47.30 PM.png" "01-main-screen.png"
mv "Screenshot 2025-10-22 at 12.48.15 PM.png" "02-control-view.png"
mv "Screenshot 2025-10-22 at 12.49.02 PM.png" "03-broadcast.png"
```

## 📤 Uploading to App Store Connect

Once you have your screenshots:

1. **Go to App Store Connect**
   - https://appstoreconnect.apple.com
   - My Apps → Bouncy Control

2. **Navigate to Screenshots Section**
   - Version 1.0.2 → App Store → Media Manager
   - Or: iOS App → 6.9" Display

3. **Upload Screenshots**
   - Drag and drop your PNG files
   - Or click "+" to browse and select
   - Minimum 3, maximum 10
   - Order matters - first screenshot shows prominently

4. **Set Preview Order**
   - Drag to reorder
   - First screenshot is most important
   - Usually: Main screen → Key feature → Additional features

## 🎨 Optional: Professional Polish

Want to make screenshots look more professional? You can:

### Add Device Frames
- Use tools like:
  - [Screenshot.rocks](https://screenshot.rocks) (free)
  - [Appure](https://appure.app) (free)
  - [AppLaunchpad](https://theapplaunchpad.com) (paid)

### Add Text/Captions
- Photoshop, Figma, Canva
- Short phrases highlighting features
- Keep it minimal and clear

### Background
- Simple gradient or solid color
- Matches your brand
- Don't distract from app content

**Note**: These are OPTIONAL. Plain screenshots work perfectly fine!

## ✅ Verification Checklist

Before uploading to App Store Connect:

- [ ] Have at least 3 screenshots
- [ ] All screenshots are 1290 x 2796 pixels
- [ ] Screenshots are PNG format
- [ ] Screenshots show real app functionality
- [ ] No placeholder/test data visible
- [ ] Status bar is visible (normal iOS bar)
- [ ] Screens are clear and easy to understand
- [ ] Screenshots are in logical order

## 🚀 Next Steps After Screenshots

Once screenshots are ready:

1. Upload to App Store Connect
2. Add app description and keywords
3. Add privacy policy URL
4. Create archive build
5. Submit for review

See `APP_STORE_CHECKLIST.md` for complete submission process.

## 🆘 Troubleshooting

### Simulator not visible
- **Solution**: Open Spotlight (⌘+Space) → "Simulator" → Enter
- Or: Applications → Xcode.app → Right-click → Show Package Contents → Applications → Simulator

### Screenshots saved to wrong location
- **Solution**: Check Desktop and Pictures folders
- Or search: Spotlight (⌘+Space) → "Screenshot"

### Wrong dimensions
- **Solution**:
  - Verify simulator: iPhone 16 Pro Max
  - Check Window → Scale → should be 100%
  - Use ⌘+S (not ⌘+Shift+4)

### Simulator is too large
- **Solution**:
  - Window → Scale → 50% or 75% (for viewing)
  - Set back to 100% before screenshots (⌘+1)
  - Screenshots will still be correct size

### Screenshots look blurry
- **Solution**:
  - Ensure simulator scale is 100%
  - Use ⌘+S (not manual cropping)
  - Don't resize after capturing

## 📝 Screenshot Script (Advanced)

Want to automate? Here's a script:

```bash
#!/bin/bash
# Take screenshots with proper naming

SHOT_DIR=~/Desktop/Bouncy\ Control\ Screenshots
mkdir -p "$SHOT_DIR"

echo "📸 Screenshot Helper"
echo ""
echo "Make sure:"
echo "1. Simulator is focused (click on it)"
echo "2. Navigate to desired screen"
echo "3. Press ENTER to capture"
echo ""

read -p "Screenshot 1 (Main Screen) - Press ENTER when ready: "
osascript -e 'tell application "Simulator" to activate'
sleep 0.5
screencapture -w "$SHOT_DIR/01-main-screen.png"
echo "✓ Captured: 01-main-screen.png"

read -p "Screenshot 2 (Control View) - Press ENTER when ready: "
osascript -e 'tell application "Simulator" to activate'
sleep 0.5
screencapture -w "$SHOT_DIR/02-control-view.png"
echo "✓ Captured: 02-control-view.png"

read -p "Screenshot 3 (Broadcast) - Press ENTER when ready: "
osascript -e 'tell application "Simulator" to activate'
sleep 0.5
screencapture -w "$SHOT_DIR/03-broadcast.png"
echo "✓ Captured: 03-broadcast.png"

echo ""
echo "✅ Screenshots saved to: $SHOT_DIR"
echo ""
echo "Verify dimensions:"
sips -g pixelWidth -g pixelHeight "$SHOT_DIR"/*.png
```

Save as `capture-screenshots.sh`, make executable:
```bash
chmod +x capture-screenshots.sh
./capture-screenshots.sh
```

---

## 🎯 Quick Start Summary

1. **Simulator is running** ✅ (iPhone 16 Pro Max)
2. **Add 2-3 demo servers** (for better screenshots)
3. **Navigate to each screen** you want to capture
4. **Press ⌘+S** to capture each screen
5. **Check Desktop** for PNG files
6. **Verify dimensions**: Should be 1290 x 2796
7. **Upload** to App Store Connect

**Time needed**: 10-15 minutes

Good luck! 📸
