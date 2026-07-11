#!/bin/bash

# Exit on any error
set -e

echo "=== Installing Flutter SDK ==="
# Clone the Flutter stable channel SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter-sdk

# Export path
export PATH="$PATH:$(pwd)/flutter-sdk/bin"

echo "=== Pre-caching Web binaries ==="
flutter precache --web

echo "=== Getting dependencies ==="
flutter pub get

echo "=== Building Flutter Web ==="
flutter build web --release --base-href "/"

echo "=== Build Completed ==="
