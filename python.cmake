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
include (BuildSupport)

include (zlib)

external_source (python
    2.7.3
    Python-2.7.3.tgz
    2cf641732ac23b18d139be077bd906cd
    http://www.python.org/ftp/python/2.7.3)

message ("Installing ${python_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")

ExternalProject_Add(${python_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${python_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        --enable-framework=${FLYEM_BUILD_DIR}/Frameworks
        LDFLAGS=${FLYEM_LDFLAGS}
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
    BUILD_IN_SOURCE 1
)

set (PYTHON_PREFIX ${FLYEM_BUILD_DIR}/Frameworks/Python.framework/Versions/2.7)
set (PYTHON_INCLUDE_PATH ${FLYEM_BUILD_DIR}/Frameworks/Python.framework/Versions/2.7/include/python2.7)
set (PYTHON_EXE ${FLYEM_BUILD_DIR}/Frameworks/Python.framework/Versions/2.7/bin/python)

endif (NOT python_NAME)
