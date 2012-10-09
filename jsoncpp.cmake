#
# Install the JsonCpp program into an OS-specific build directory
#

if (NOT jsoncpp_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (SetBuildDir)
include (CacheDownload)

set (scons_RELEASE  1.2.0)
set (scons_NAME     "scons-local-${scons_RELEASE}")

set (jsoncpp_RELEASE  0.5.0)
set (jsoncpp_NAME     "jsoncpp-src-${jsoncpp_RELEASE}")

cache_init (scons ${scons_NAME}.tar.gz http://downloads.sourceforge.net/project/scons/scons-local/1.2.0)
cache_init (jsoncpp ${jsoncpp_NAME}.tar.gz http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0)

# Copy script will take a string pattern and copy all matches into a destination directory.
# Surprisingly, this is hard to do within ExternalProject_Add due to lack of wildcard expansion?
# TODO -- Find some CMake equivalent although initial attempts have been unsuccessful.
set (COPY_SCRIPT ${FLYEM_BUILD_REPO_DIR}/copy.py)

# Download required scons local package
message ("Installing scons-local 1.2.0 needed to build jsoncpp...")
set_src_dir(scons ${scons_NAME})

ExternalProject_Add(${scons_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${scons_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)
cache_download (scons)

# Download jsoncpp and build it.
message ("Installing ${jsoncpp_NAME} ...")
set_src_dir(jsoncpp ${jsoncpp_NAME})

ExternalProject_Add(${jsoncpp_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    DEPENDS ${scons_NAME}
    URL ${jsoncpp_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND python ${COPY_SCRIPT} "${scons_SRC_DIR}/*" ${jsoncpp_SRC_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND python scons.py platform=linux-gcc
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
)
cache_download (jsoncpp)

add_custom_command (TARGET ${jsoncpp_NAME}
                    POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/lib
                    COMMAND ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/include
                    COMMAND ${CMAKE_COMMAND} -E copy ${jsoncpp_SRC_DIR}/libs/linux-gcc-*/libjson_linux-gcc-*_libmt.so ${FLYEM_BUILD_DIR}/lib/libjsoncpp.so
                    COMMAND python ${COPY_SCRIPT} "${jsoncpp_SRC_DIR}/include/*" ${FLYEM_BUILD_DIR}/include
                    COMMENT "Copied jsoncpp library and include files to ${FLYEM_BUILD_DIR}")
set (json_LIB ${FLYEM_BUILD_DIR}/lib/libjsoncpp.so)
set (json_INCLUDES ${FLYEM_BUILD_DIR}/include)

message ("Including JSON include files from here: ${json_INCLUDES}")

endif (NOT jsoncpp_NAME)