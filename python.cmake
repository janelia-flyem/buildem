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
include (openssl)   # without openssl, hashlib might have missing encryption methods

external_source (python
    2.7.3
    Python-2.7.3.tgz
    2cf641732ac23b18d139be077bd906cd
    http://www.python.org/ftp/python/2.7.3)

message ("Installing ${python_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac, we build a "Framework" build which has all the power of a "normal" build, 
    #  plus it can be used from a native GUI.
    # See http://svn.python.org/projects/python/trunk/Mac/README
    set (PYTHON_BUILD_TYPE_ARG "--enable-framework=${BUILDEM_DIR}/Frameworks")
    set (PYTHON_PREFIX ${BUILDEM_DIR}/Frameworks/Python.framework/Versions/2.7)
else()
    # On linux, PYTHON_PREFIX is the same as the general prefix.
    set (PYTHON_BUILD_TYPE_ARG "--enable-shared")
    set (PYTHON_PREFIX ${BUILDEM_DIR})
endif()

ExternalProject_Add(${python_NAME}
    DEPENDS             ${zlib_NAME} ${openssl_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${python_SRC_DIR}/configure 
        --prefix=${BUILDEM_DIR}
        ${PYTHON_BUILD_TYPE_ARG}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    BUILD_IN_SOURCE 1 # Required for Mac
)

set (PYTHON_INCLUDE_PATH ${PYTHON_PREFIX}/include/python2.7)
set (PYTHON_EXE ${PYTHON_PREFIX}/bin/python)

endif (NOT python_NAME)
