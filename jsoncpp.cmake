#
# Install the JsonCpp program into an OS-specific build directory
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (SetBuildDir)

# Copy script will take a string pattern and copy all matches into a destination directory.
# Surprisingly, this is hard to do within ExternalProject_Add due to lack of wildcard expansion?
# TODO -- Find some CMake equivalent although initial attempts have been unsuccessful.
set (COPY_SCRIPT ${FLYEM_BUILD_REPO_DIR}/copy.py)

# Download required scons local package
message ("Installing scons-local 1.2.0 needed to build jsoncpp...")
ExternalProject_Add(scons-local-1.2.0
    PREFIX ${FLYEM_BUILD_DIR}
    URL http://downloads.sourceforge.net/project/scons/scons-local/1.2.0/scons-local-1.2.0.tar.gz
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

# Download jsoncpp and build it.
set (jsoncpp_RELEASE  0.5.0)
set (jsoncpp_NAME     "jsoncpp-src-${jsoncpp_RELEASE}")

message ("Installing ${jsoncpp_NAME} ...")
set_src_dir(jsoncpp ${jsoncpp_NAME})
include_directories (${jsoncpp_SRC_DIR}/include)
message ("Including JSON include files from here: ${jsoncpp_SRC_DIR}/include")

ExternalProject_Add(${jsoncpp_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    DEPENDS scons-local-1.2.0
    URL http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz
    UPDATE_COMMAND ""
    PATCH_COMMAND python ${COPY_SCRIPT} "${FLYEM_BUILD_DIR}/src/scons-local-1.2.0/*" ${jsoncpp_SRC_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND python scons.py platform=linux-gcc
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND ""
)

add_custom_command (TARGET ${jsoncpp_NAME}
                    POST_BUILD
                    COMMAND mkdir -p ${FLYEM_BUILD_DIR}/lib
                    COMMAND mkdir -p ${FLYEM_BUILD_DIR}/include
                    COMMAND cp ${jsoncpp_SRC_DIR}/libs/linux-gcc-*/libjson_linux-gcc-*_libmt.so ${FLYEM_BUILD_DIR}/lib/libjsoncpp.so
                    COMMAND python ${COPY_SCRIPT} "${jsoncpp_SRC_DIR}/include/*" ${FLYEM_BUILD_DIR}/include
                    COMMENT "Copied jsoncpp library and include files to ${FLYEM_BUILD_DIR}")
set (json_LIB ${FLYEM_BUILD_DIR}/lib/libjsoncpp.so)
set (json_INCLUDES ${FLYEM_BUILD_DIR}/include)
