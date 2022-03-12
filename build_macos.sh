# Clone dawn
git clone https://dawn.googlesource.com/dawn
cd dawn

# Clone depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# Sync gclient
cp scripts/standalone.gclient .gclient
PATH="$PWD/depot_tools:$PATH" gclient sync

# Setup for building
mkdir -p out/Release_x64
mkdir -p out/Release_arm64

echo "is_debug=false
use_system_xcode=true
target_cpu=\"x64\"" > out/Release_x64/args.gn

echo "is_debug=false
use_system_xcode=true
target_cpu=\"arm64\"" > out/Release_arm64/args.gn

PATH="$PWD/depot_tools:$PATH" gn gen out/Release_x64
PATH="$PWD/depot_tools:$PATH" gn gen out/Release_arm64

# Build
PATH="$PWD/depot_tools:$PATH" ninja -C out/Release_x64/ src/dawn/native:shared src/dawn:proc_shared
PATH="$PWD/depot_tools:$PATH" ninja -C out/Release_arm64/ src/dawn/native:shared src/dawn:proc_shared