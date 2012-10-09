#
# Install python from source
#
# Defines the following:
#    PYTHON_INCLUDE_PATH
#    PYTHON_EXE -- path to python executable

if (NOT python_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (python
    2.7.3
    Python-2.7.3.tgz
    http://www.python.org/ftp/python/2.7.3)

message ("Installing ${python_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${python_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${python_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${python_SRC_DIR}/configure --prefix=${FLYEM_BUILD_DIR}
    BUILD_COMMAND make
    INSTALL_COMMAND make install
)

set (PYTHON_INCLUDE_PATH ${FLYEM_BUILD_DIR}/include/python2.7)
set (PYTHON_EXE ${FLYEM_BUILD_DIR}/bin/python2.7)

endif (NOT python_NAME)