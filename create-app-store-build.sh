#!/bin/bash

# App Store Archive & Export Script for Bouncy Control
# This script creates an archive and exports it for App Store submission

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_PATH="Bouncy Control.xcodeproj"
SCHEME="Bouncy Control"
CONFIGURATION="Release"
ARCHIVE_PATH="./build/Bouncy Control.xcarchive"
EXPORT_PATH="./build/AppStore"
EXPORT_OPTIONS="ExportOptions.plist"

echo ""
echo "${GREEN}================================================${NC}"
echo "${GREEN}  Bouncy Control - App Store Build Script${NC}"
echo "${GREEN}================================================${NC}"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "${RED}Error: xcodebuild not found. Please install Xcode.${NC}"
    exit 1
fi

# Check if ExportOptions.plist exists
if [ ! -f "$EXPORT_OPTIONS" ]; then
    echo "${RED}Error: ExportOptions.plist not found${NC}"
    echo "Please ensure ExportOptions.plist is in the project root directory"
    exit 1
fi

# Check if project exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "${RED}Error: Project not found at $PROJECT_PATH${NC}"
    exit 1
fi

echo "${YELLOW}Step 1/5: Cleaning build folder...${NC}"
xcodebuild clean -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    | grep -A 5 "CLEAN SUCCEEDED" || true

echo ""
echo "${GREEN}✓ Clean completed${NC}"
echo ""

# Create build directory
mkdir -p "./build"

echo "${YELLOW}Step 2/5: Creating archive (this may take a few minutes)...${NC}"
xcodebuild archive \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM=YBX2V97SYB \
    -allowProvisioningUpdates \
    | grep -E "Archive Succeeded|error:" || true

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo ""
    echo "${RED}Error: Archive creation failed${NC}"
    echo "Check the output above for errors"
    exit 1
fi

echo ""
echo "${GREEN}✓ Archive created successfully${NC}"
echo "${GREEN}  Location: $ARCHIVE_PATH${NC}"
echo ""

echo "${YELLOW}Step 3/5: Validating archive...${NC}"
# Check if archive contains the app
if [ ! -d "$ARCHIVE_PATH/Products/Applications/Bouncy Control.app" ]; then
    echo "${RED}Error: Archive is missing the application${NC}"
    exit 1
fi

echo "${GREEN}✓ Archive validated${NC}"
echo ""

echo "${YELLOW}Step 4/5: Exporting for App Store...${NC}"
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS" \
    -allowProvisioningUpdates \
    | grep -E "Export Succeeded|error:" || true

if [ ! -f "$EXPORT_PATH/Bouncy Control.ipa" ]; then
    echo ""
    echo "${RED}Error: Export failed${NC}"
    echo "Check the output above for errors"
    exit 1
fi

echo ""
echo "${GREEN}✓ Export completed successfully${NC}"
echo ""

echo "${YELLOW}Step 5/5: Generating build info...${NC}"

# Get file size
IPA_SIZE=$(du -h "$EXPORT_PATH/Bouncy Control.ipa" | cut -f1)

# Get version info
VERSION=$(defaults read "$(pwd)/Bouncy-Control-Info.plist" CFBundleShortVersionString 2>/dev/null || echo "Unknown")
BUILD=$(defaults read "$(pwd)/Bouncy-Control-Info.plist" CFBundleVersion 2>/dev/null || echo "Unknown")

echo ""
echo "${GREEN}================================================${NC}"
echo "${GREEN}          BUILD COMPLETED SUCCESSFULLY!${NC}"
echo "${GREEN}================================================${NC}"
echo ""
echo "Archive Location: $ARCHIVE_PATH"
echo "IPA Location: $EXPORT_PATH/Bouncy Control.ipa"
echo "IPA Size: $IPA_SIZE"
echo "Version: $VERSION (Build $BUILD)"
echo ""
echo "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. ${GREEN}Via Xcode Organizer (Recommended):${NC}"
echo "   - Open Xcode → Window → Organizer"
echo "   - Select your archive"
echo "   - Click 'Distribute App'"
echo "   - Choose 'App Store Connect'"
echo "   - Click 'Upload'"
echo ""
echo "2. ${GREEN}Via Transporter App:${NC}"
echo "   - Open Transporter.app"
echo "   - Drag '$EXPORT_PATH/Bouncy Control.ipa' to Transporter"
echo "   - Click 'Deliver'"
echo ""
echo "3. ${GREEN}Via Command Line:${NC}"
echo "   xcrun altool --upload-app \\"
echo "     -f '$EXPORT_PATH/Bouncy Control.ipa' \\"
echo "     -t ios \\"
echo "     -u 'your-apple-id@email.com' \\"
echo "     -p '@keychain:AC_PASSWORD'"
echo ""
echo "${YELLOW}Remember to:${NC}"
echo "- Complete all required fields in App Store Connect"
echo "- Upload screenshots"
echo "- Add privacy policy URL"
echo "- Write review notes explaining HTTP usage"
echo ""
echo "${GREEN}Good luck with your submission! 🚀${NC}"
echo ""
