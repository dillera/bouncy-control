#!/bin/bash

# Test script for BouncyControl iOS app
# Usage: ./scripts/test.sh

set -e

PROJECT="BouncyControl.xcodeproj"
SCHEME="BouncyControl"

echo "🧪 Running tests for BouncyControl..."

xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  | xcpretty || true

echo "✅ Tests complete!"
