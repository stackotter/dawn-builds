# Clone dawn
git clone https://dawn.googlesource.com/dawn
cd dawn

# Clone depot_tools
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# Sync gclient
cp scripts/standalone.gclient .gclient
PATH="$PWD/depot_tools:$PATH" gclient sync

# Setup build configurations
mkdir -p out/Release_x64
mkdir -p out/Release_arm64

echo "is_debug=false
use_system_xcode=true
target_cpu=\"x64\"" > out/Release_x64/args.gn

echo "is_debug=false
use_system_xcode=true
target_cpu=\"arm64\"" > out/Release_arm64/args.gn

# Generate ninja project
PATH="$PWD/depot_tools:$PATH" gn gen out/Release_x64
PATH="$PWD/depot_tools:$PATH" gn gen out/Release_arm64

# Build
PATH="$PWD/depot_tools:$PATH" ninja -C out/Release_x64/ src/dawn/native:shared src/dawn:proc_shared
PATH="$PWD/depot_tools:$PATH" ninja -C out/Release_arm64/ src/dawn/native:shared src/dawn:proc_shared

cd ..

# Copy headers
rm -rf build
mkdir -p build/include
cp -R dawn/include/* build/include
cp -R dawn/out/Release_x64/gen/include/* build/include # Assumes headers are the same for both architectures

# Copy binaries
mkdir -p build/lib/x64
mkdir -p build/lib/arm64
cp dawn/out/Release_x64/*.dylib build/lib/x64
cp dawn/out/Release_arm64/*.dylib build/lib/arm64

# Merge binaries into universal binaries
cd build/lib
lipo -create -output libdawn_native.dylib x64/libdawn_native.dylib arm64/libdawn_native.dylib
lipo -create -output libdawn_proc.dylib x64/libdawn_proc.dylib arm64/libdawn_proc.dylib
lipo -create -output libEGL.dylib x64/libEGL.dylib arm64/libEGL.dylib
lipo -create -output libGLESv2.dylib x64/libGLESv2.dylib arm64/libGLESv2.dylib
lipo -create -output libvk_swiftshader.dylib x64/libvk_swiftshader.dylib arm64/libvk_swiftshader.dylib
lipo -create -output libVkICD_mock_icd.dylib x64/libVkICD_mock_icd.dylib arm64/libVkICD_mock_icd.dylib
lipo -create -output libVkLayer_khronos_validation.dylib x64/libVkLayer_khronos_validation.dylib arm64/libVkLayer_khronos_validation.dylib
cd ../..

# Copy dawn.json
cp dawn/dawn.json build/lib

# Clean up build directory
rm -rf build/lib/arm64
rm -rf build/lib/x64

# Zip build
zip -r build.zip build