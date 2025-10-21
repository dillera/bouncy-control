#!/bin/bash

# SwiftLint script for BouncyControl iOS app
# Usage: ./scripts/lint.sh [fix]

set -e

MODE="${1:-check}"

if ! command -v swiftlint &> /dev/null; then
    echo "⚠️  SwiftLint not installed. Installing via Homebrew..."
    brew install swiftlint
fi

echo "🔍 Running SwiftLint..."

case $MODE in
  fix)
    echo "🔧 Auto-fixing issues..."
    swiftlint --fix
    swiftlint lint
    ;;

  check|*)
    swiftlint lint
    ;;
esac

echo "✅ Linting complete!"
