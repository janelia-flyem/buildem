#
# Install the JsonCpp program into an OS-specific build directory
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (SetBuildDir)

set (python_RELEASE  2.7.3)
set (python_NAME     "Python-${python_RELEASE}")
set_src_dir (python ${python_NAME})

ExternalProject_Add(${python_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL http://www.python.org/ftp/python/2.7.3/${python_NAME}.tgz
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${python_SRC_DIR}/configure --prefix=${FLYEM_BUILD_DIR}
    BUILD_COMMAND make
    INSTALL_COMMAND make install
)

message ("Will use python ${python_RELEASE} for build.")