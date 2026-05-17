#!/bin/bash
# Context detection for Claude Code XcodeBuildMCP integration
# This script analyzes the current context and sets appropriate defaults

# Get absolute project root (Claude Code always runs from project root)
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CURRENT_DIR=$(pwd)

# Function to find project file
find_project_file() {
    # Look for xcworkspace first (takes precedence)
    local workspace=$(find "$PROJECT_ROOT" -name "*.xcworkspace" -maxdepth 2 | grep -v xcodeproj | head -1)
    if [ -n "$workspace" ]; then
        echo "$workspace"
        return
    fi
    
    # Fall back to xcodeproj
    local project=$(find "$PROJECT_ROOT" -name "*.xcodeproj" -maxdepth 2 | head -1)
    if [ -n "$project" ]; then
        echo "$project"
        return
    fi
}

# Function to detect default scheme
detect_default_scheme() {
    local project_file="$1"
    if [ -n "$project_file" ]; then
        # Try to extract the main scheme
        xcodebuild -list -project "$project_file" 2>/dev/null | \
            grep -A10 "Schemes:" | \
            grep -v "Schemes:" | \
            head -1 | \
            xargs
    fi
}

# Function to find newest simulator
find_newest_simulator() {
    xcrun simctl list devices available | \
        grep "iPhone" | \
        grep -v "unavailable" | \
        tail -1 | \
        sed 's/.*(\(.*\)).*/\1/'
}

# Detect project configuration
PROJECT_FILE=$(find_project_file)
DEFAULT_SCHEME=$(detect_default_scheme "$PROJECT_FILE")
DEFAULT_SIMULATOR=$(find_newest_simulator)

# Export for MCP tools
export XCODEBUILDMCP_PROJECT_ROOT="$PROJECT_ROOT"
export XCODEBUILDMCP_DEFAULT_PROJECT="$PROJECT_FILE"
export XCODEBUILDMCP_DEFAULT_SCHEME="${DEFAULT_SCHEME:-YourApp}"
export XCODEBUILDMCP_DEFAULT_SIMULATOR="${DEFAULT_SIMULATOR:-iPhone 15}"

# Detect if we're in a package directory
if [ -f "Package.swift" ]; then
    export XCODEBUILDMCP_CONTEXT="package"
    export XCODEBUILDMCP_PACKAGE_PATH="$CURRENT_DIR"
elif [[ "$CURRENT_DIR" == *"Tests"* ]]; then
    export XCODEBUILDMCP_CONTEXT="tests"
elif [[ "$CURRENT_DIR" == *"UITests"* ]]; then
    export XCODEBUILDMCP_CONTEXT="uitests"
else
    export XCODEBUILDMCP_CONTEXT="app"
fi

# Check for booted simulator
BOOTED_SIM=$(xcrun simctl list devices | grep "Booted" | head -1 | awk -F'[()]' '{print $2}')
if [ -n "$BOOTED_SIM" ]; then
    export XCODEBUILDMCP_BOOTED_SIMULATOR="$BOOTED_SIM"
fi

# Check for connected physical devices
if xcrun devicectl list devices 2>/dev/null | grep -q "iPhone\|iPad"; then
    export XCODEBUILDMCP_HAS_DEVICE="true"
fi

# Output context (useful for debugging)
if [ "${DEBUG_CONTEXT}" = "true" ]; then
    echo "Context Detection Results:"
    echo "  Project: $PROJECT_FILE"
    echo "  Scheme: $DEFAULT_SCHEME"
    echo "  Simulator: $DEFAULT_SIMULATOR"
    echo "  Context: $XCODEBUILDMCP_CONTEXT"
    echo "  Has Device: ${XCODEBUILDMCP_HAS_DEVICE:-false}"
fi