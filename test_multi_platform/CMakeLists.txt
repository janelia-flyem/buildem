cmake_minimum_required(VERSION 2.8)
project(bar NONE)

SET(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  ${bar_SOURCE_DIR}/..)

include(ExternalProjectMultiPlatform)

# try it for 6 platforms
SET(DRY_RUN YES)

MESSAGE("**********************")
foreach(PLATFORM_SPEC "B" "B C" "Q" "T" "X" "X Y")
    MESSAGE("dry-run for platform: ${PLATFORM_SPEC}")

    ExternalProject_AddMultiPlatform(foo 
        DEPENDS baz
      PLATFORM B
        PATCH_COMMAND patch patchfile
        BUILD_COMMAND make
        INSTALL_COMMAND make install
      PLATFORM B C
        INSTALL_COMMAND install.sh
      PLATFORM Q
        BUILD_COMMAND devenv
        INSTALL_COMMAND ""
      PLATFORM X
        UNSUPPORTED
      PLATFORM X Y
        BUILD_COMMAND nmake
    )
    MESSAGE("**********************")
endforeach(PLATFORM_SPEC)

# do the real thing
SET(DRY_RUN NO)

MESSAGE("**********************")
foreach(PLATFORM_SPEC "B C")
    MESSAGE("real run for platform: ${PLATFORM_SPEC}")

    ExternalProject_AddMultiPlatform(foo 
      PLATFORM B
        SOURCE_DIR ./foo
        DOWNLOAD_COMMAND ""
        BINARY_DIR ./foo
        CONFIGURE_COMMAND cmake .
        BUILD_COMMAND  devenv foo.sln /build Release /project foo1
                     \ndevenv foo.sln /build Release /project foo2
        INSTALL_COMMAND devenv foo.sln /build Release /project INSTALL
      PLATFORM B C
        INSTALL_COMMAND install.bat    
    )
    MESSAGE("**********************")
endforeach(PLATFORM_SPEC)
