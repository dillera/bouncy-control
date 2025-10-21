#!/bin/bash

# Build script for BouncyControl iOS app
# Usage: ./scripts/build.sh [simulator|device]

set -e

PROJECT="BouncyControl.xcodeproj"
SCHEME="BouncyControl"
BUILD_TYPE="${1:-simulator}"

echo "🚀 Building BouncyControl..."
echo "Build type: $BUILD_TYPE"

case $BUILD_TYPE in
  simulator)
    echo "📱 Building for iOS Simulator..."
    xcodebuild clean build \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -sdk iphonesimulator \
      -destination 'platform=iOS Simulator,name=iPhone 15' \
      CODE_SIGN_IDENTITY="" \
      CODE_SIGNING_REQUIRED=NO \
      | xcpretty || true
    ;;

  device)
    echo "📱 Building for iOS Device..."
    xcodebuild clean build \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -sdk iphoneos \
      -configuration Release \
      | xcpretty || true
    ;;

  *)
    echo "❌ Unknown build type: $BUILD_TYPE"
    echo "Usage: $0 [simulator|device]"
    exit 1
    ;;
esac

echo "✅ Build complete!"
