# Geode Networking Libs

Build curl (8.8.0) with
- TLS (BoringSSL)
- HTTP2 (nghttp2 1.62.1)
- HTTP3 (ngtcp2 1.5.0, nghttp3 1.3.0)

## Cloning

```
git clone --recurse-submodules -j$(nproc) https://github.com/kynex7510/geode_net_libs
```

## Build notes

### Windows build

The powershell script must be launched from a VS dev command line.

### Patching curl

When compiling for android BoringSSL links to `libc++`. `CMakeFiles.txt` from curl must be modified to allow tests to pass.

1. `project(CURL C)` -> `project(CURL C CXX)`
2. Add `include(CheckCXXSymbolExists)`
3. Locate `openssl_check_symbol_exists` and change `check_symbol_exists` to `check_cxx_symbol_exists` at the end