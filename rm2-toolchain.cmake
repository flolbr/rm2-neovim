# Toltec's ARMv7 hard-float sysroot, suitable for reMarkable 2 devices.
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)
set(CMAKE_SYSROOT /opt/x-tools/arm-remarkable-linux-gnueabihf/arm-remarkable-linux-gnueabihf/sysroot)
set(CMAKE_FIND_ROOT_PATH "${CMAKE_SYSROOT}" "/project/build/neovim/.deps/usr")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# CMake configure checks must not try to execute ARM binaries on the host.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
