#!/bin/bash

ROOT=$PWD
#ABI="arm64-v8a"
ABI="armeabi-v7a"
SDK_VER=23
BUILD_PATH="$ROOT/build/android32"
OUT_PATH="$ROOT/out/android32"

# Remove previous output files

rm -rf "$OUT_PATH"

# Build BoringSSL

rm -rf "$BUILD_PATH/boringssl"
mkdir -p "$BUILD_PATH/boringssl"
cd "$BUILD_PATH/boringssl"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$OUT_PATH" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI=$ABI -DANDROID_PLATFORM=android-$SDK_VER "$ROOT/boringssl"
make -j$(nproc)
make install
make clean

# Build nghttp2

rm -rf "$BUILD_PATH/nghttp2"
mkdir -p "$BUILD_PATH/nghttp2"
cd "$BUILD_PATH/nghttp2"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$OUT_PATH" -DENABLE_LIB_ONLY=ON -DENABLE_EXAMPLES=OFF \
    -DBUILD_TESTING=OFF -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" -DANDROID_ABI=$ABI \
    -DANDROID_PLATFORM=android-$SDK_VER -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON "$ROOT/nghttp2"
make -j$(nproc)
make install
make clean

# Build ngtcp2

#rm -rf "$BUILD_PATH/ngtcp2"
#mkdir -p "$BUILD_PATH/ngtcp2"
#cd "$BUILD_PATH/ngtcp2"

#"$ROOT/ngtcp2/configure" --host $TARGET --prefix="$OUT_PATH" --disable-shared
#make -j$(nproc)
#make install
#make clean

# Build curl

rm -rf "$BUILD_PATH/curl"
mkdir -p "$BUILD_PATH/curl"
cd "$BUILD_PATH/curl"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$OUT_PATH" -DBUILD_CURL_EXE=OFF \
    -DCURL_USE_OPENSSL=ON -DOPENSSL_INCLUDE_DIR="$OUT_PATH/include" \
    -DOPENSSL_CRYPTO_LIBRARY="$OUT_PATH/lib/libcrypto.a" -DOPENSSL_SSL_LIBRARY="$OUT_PATH/lib/libssl.a" \
    -DUSE_NGHTTP2=ON -DNGHTTP2_INCLUDE_DIR="$OUT_PATH/include" -DNGHTTP2_LIBRARY="$OUT_PATH/lib/libnghttp2.a" \
    -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake" -DANDROID_ABI=$ABI \
    -DANDROID_PLATFORM=android-$SDK_VER -DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON "$ROOT/curl"
make -j$(nproc)
make install
make clean