#!/bin/bash

# Screenshot Verification Script for Bouncy Control
# Checks that screenshots meet App Store requirements

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Required dimensions for iPhone 16 Pro Max
REQUIRED_WIDTH=1290
REQUIRED_HEIGHT=2796

echo ""
echo "${BLUE}================================================${NC}"
echo "${BLUE}  Screenshot Verification Tool${NC}"
echo "${BLUE}  Bouncy Control App Store Submission${NC}"
echo "${BLUE}================================================${NC}"
echo ""

# Check if screenshots directory exists
SCREENSHOT_DIR="$HOME/Desktop"
CUSTOM_DIR="$HOME/Desktop/Bouncy Control Screenshots"

if [ -d "$CUSTOM_DIR" ]; then
    SCREENSHOT_DIR="$CUSTOM_DIR"
    echo "${GREEN}Using organized screenshot directory${NC}"
else
    echo "${YELLOW}Looking for screenshots on Desktop${NC}"
fi

# Find screenshot files
if [ -d "$CUSTOM_DIR" ]; then
    SCREENSHOTS=($(find "$CUSTOM_DIR" -name "*.png" -type f))
else
    SCREENSHOTS=($(find "$SCREENSHOT_DIR" -maxdepth 1 -name "Screenshot*.png" -o -name "bouncy-control*.png" -o -name "*main*.png" -o -name "*control*.png" -o -name "*broadcast*.png" | head -10))
fi

if [ ${#SCREENSHOTS[@]} -eq 0 ]; then
    echo "${RED}❌ No screenshots found!${NC}"
    echo ""
    echo "Expected locations:"
    echo "  - $SCREENSHOT_DIR/Screenshot*.png"
    echo "  - $CUSTOM_DIR/*.png"
    echo ""
    echo "To capture screenshots:"
    echo "  1. Make sure iPhone 16 Pro Max simulator is running"
    echo "  2. Navigate to desired screen in your app"
    echo "  3. Press ⌘+S (Command + S)"
    echo "  4. Screenshot saves to Desktop"
    echo ""
    exit 1
fi

echo "${GREEN}Found ${#SCREENSHOTS[@]} screenshot(s)${NC}"
echo ""

# Verify each screenshot
VALID_COUNT=0
INVALID_COUNT=0
WARNINGS=()

for SCREENSHOT in "${SCREENSHOTS[@]}"; do
    FILENAME=$(basename "$SCREENSHOT")
    echo "Checking: ${BLUE}$FILENAME${NC}"

    # Get dimensions
    WIDTH=$(sips -g pixelWidth "$SCREENSHOT" | awk '/pixelWidth:/ {print $2}')
    HEIGHT=$(sips -g pixelHeight "$SCREENSHOT" | awk '/pixelHeight:/ {print $2}')

    # Get file size
    SIZE=$(du -h "$SCREENSHOT" | cut -f1)

    # Check dimensions
    if [ "$WIDTH" -eq "$REQUIRED_WIDTH" ] && [ "$HEIGHT" -eq "$REQUIRED_HEIGHT" ]; then
        echo "  ${GREEN}✓${NC} Dimensions: ${WIDTH}x${HEIGHT} pixels (correct)"
        echo "  ${GREEN}✓${NC} File size: $SIZE"
        VALID_COUNT=$((VALID_COUNT + 1))
    else
        echo "  ${RED}✗${NC} Dimensions: ${WIDTH}x${HEIGHT} pixels"
        echo "  ${RED}✗${NC} Expected: ${REQUIRED_WIDTH}x${REQUIRED_HEIGHT} pixels"
        echo "  ${YELLOW}⚠${NC}  This screenshot will NOT work for App Store!"
        INVALID_COUNT=$((INVALID_COUNT + 1))
        WARNINGS+=("$FILENAME has wrong dimensions ($WIDTHx$HEIGHT)")
    fi

    # Check file format
    FILE_TYPE=$(file -b "$SCREENSHOT" | awk '{print $1}')
    if [[ "$FILE_TYPE" == "PNG" ]]; then
        echo "  ${GREEN}✓${NC} Format: PNG (correct)"
    else
        echo "  ${YELLOW}⚠${NC}  Format: $FILE_TYPE (should be PNG)"
        WARNINGS+=("$FILENAME is not PNG format")
    fi

    echo ""
done

# Summary
echo "${BLUE}================================================${NC}"
echo "${BLUE}  VERIFICATION SUMMARY${NC}"
echo "${BLUE}================================================${NC}"
echo ""
echo "Total screenshots found: ${#SCREENSHOTS[@]}"
echo "Valid screenshots: ${GREEN}$VALID_COUNT${NC}"
echo "Invalid screenshots: ${RED}$INVALID_COUNT${NC}"
echo ""

# Requirements check
echo "App Store Requirements:"
if [ $VALID_COUNT -ge 3 ]; then
    echo "  ${GREEN}✓${NC} Minimum 3 valid screenshots (have $VALID_COUNT)"
else
    echo "  ${RED}✗${NC} Need at least 3 valid screenshots (have $VALID_COUNT)"
fi

if [ $VALID_COUNT -le 10 ]; then
    echo "  ${GREEN}✓${NC} Maximum 10 screenshots (have $VALID_COUNT)"
else
    echo "  ${YELLOW}⚠${NC}  More than 10 screenshots (have $VALID_COUNT)"
    echo "      App Store accepts max 10 per device size"
fi

# Warnings
if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo ""
    echo "${YELLOW}⚠  WARNINGS:${NC}"
    for WARNING in "${WARNINGS[@]}"; do
        echo "  - $WARNING"
    done
fi

echo ""

# Final verdict
if [ $VALID_COUNT -ge 3 ] && [ $INVALID_COUNT -eq 0 ]; then
    echo "${GREEN}✅ SUCCESS! Your screenshots are ready for App Store submission!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Go to https://appstoreconnect.apple.com"
    echo "  2. My Apps → Bouncy Control → Version 1.0.2"
    echo "  3. App Store → Media Manager → 6.9\" Display"
    echo "  4. Drag and drop your screenshots"
    echo ""
    if [ -d "$CUSTOM_DIR" ]; then
        echo "Your screenshots are in: $CUSTOM_DIR"
    else
        echo "Your screenshots are on Desktop"
    fi
elif [ $VALID_COUNT -ge 3 ]; then
    echo "${YELLOW}⚠  PARTIAL SUCCESS${NC}"
    echo "You have enough valid screenshots ($VALID_COUNT)"
    echo "But $INVALID_COUNT screenshot(s) won't work for App Store"
    echo "You can proceed with the valid ones"
elif [ $VALID_COUNT -gt 0 ]; then
    echo "${RED}❌ NOT READY${NC}"
    echo "Need at least 3 valid screenshots"
    echo "You have $VALID_COUNT valid, need $((3 - VALID_COUNT)) more"
    echo ""
    echo "To fix:"
    echo "  1. Open Xcode"
    echo "  2. Run app on iPhone 16 Pro Max simulator"
    echo "  3. Ensure simulator Window → Scale is 100% (⌘+1)"
    echo "  4. Press ⌘+S to capture more screenshots"
else
    echo "${RED}❌ NO VALID SCREENSHOTS${NC}"
    echo ""
    echo "To fix:"
    echo "  1. Open Xcode"
    echo "  2. Run app on iPhone 16 Pro Max simulator"
    echo "  3. Set Window → Scale → 100% (⌘+1)"
    echo "  4. Press ⌘+S to capture screenshots"
    echo "  5. Run this script again to verify"
fi

echo ""

# Offer to organize screenshots
if [ $VALID_COUNT -gt 0 ] && [ ! -d "$CUSTOM_DIR" ]; then
    echo "${BLUE}Would you like to organize valid screenshots into a folder?${NC}"
    read -p "Create '$CUSTOM_DIR'? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$CUSTOM_DIR"
        for SCREENSHOT in "${SCREENSHOTS[@]}"; do
            # Check if valid
            WIDTH=$(sips -g pixelWidth "$SCREENSHOT" | awk '/pixelWidth:/ {print $2}')
            HEIGHT=$(sips -g pixelHeight "$SCREENSHOT" | awk '/pixelHeight:/ {print $2}')
            if [ "$WIDTH" -eq "$REQUIRED_WIDTH" ] && [ "$HEIGHT" -eq "$REQUIRED_HEIGHT" ]; then
                cp "$SCREENSHOT" "$CUSTOM_DIR/"
                echo "  Copied: $(basename "$SCREENSHOT")"
            fi
        done
        echo ""
        echo "${GREEN}✓${NC} Valid screenshots copied to: $CUSTOM_DIR"
        echo ""
    fi
fi

echo "${BLUE}================================================${NC}"
echo ""
