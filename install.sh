#!/bin/bash

echo "📱 Choose an option:"
echo "1. Create APK only"
echo "2. Create APK and install it"
echo "3. Install existing APK"

read -p "Enter your choice (1/2/3): " choice

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

case $choice in
  1)
    echo "🔍 Checking connected devices..."
    adb devices

    echo "🚀 Building Flutter APK (release mode - prod flavor)..."
    flutter build apk --release 

    if [ $? -ne 0 ]; then
      echo "❌ Build failed. Exiting..."
      exit 1
    fi

    echo "✅ APK build complete. File located at: $APK_PATH"
    ;;

  2)
    echo "🔍 Checking connected devices..."
    adb devices

    echo "🚀 Building Flutter APK (release mode - prod flavor)..."
    flutter build apk --release 

    if [ $? -ne 0 ]; then
      echo "❌ Build failed. Exiting..."
      exit 1
    fi

    echo "📱 Installing APK to connected device..."
    flutter install

    if [ $? -eq 0 ]; then
      echo "✅ App installed successfully!"
    else
      echo "❌ Installation failed."
    fi
    ;;

  3)
    echo "🔍 Checking connected devices..."
    adb devices

    if [ -f "$APK_PATH" ]; then
      echo "📥 Installing existing APK from: $APK_PATH"
      adb install -r "$APK_PATH"

      if [ $? -eq 0 ]; then
        echo "✅ App installed successfully!"
      else
        echo "❌ Installation failed."
      fi
    else
      echo "❌ APK not found at $APK_PATH. Please build it first."
      exit 1
    fi
    ;;

  *)
    echo "⚠️ Invalid choice. Exiting..."
    exit 1
    ;;
esac
# #!/bin/bash

# echo "🔍 Checking connected devices..."
# adb devices

# echo "🚀 Building Flutter APK (release mode - prod flavor)..."
# flutter build apk --release 

# if [ $? -ne 0 ]; then
#   echo "❌ Build failed. Exiting..."
#   exit 1
# fi

# echo "📱 Installing APK to connected device..."
# flutter install

# if [ $? -eq 0 ]; then
#   echo "✅ App installed successfully!"
# else
#   echo "❌ Installation failed."
# fi

