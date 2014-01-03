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
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) 
	PYTHONAPPSDIR=${BUILDEM_BIN_DIR}/${python_NAME} install
    BUILD_IN_SOURCE 1 # Required for Mac
)

set (PYTHON_INCLUDE_PATH ${PYTHON_PREFIX}/include/python2.7)
set (PYTHON_LIBRARY_FILE ${PYTHON_PREFIX}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION})
set (PYTHON_EXE ${PYTHON_PREFIX}/bin/python)
set (BUILDEM_PYTHONPATH  ${PYTHON_PREFIX}/lib/python2.7:${PYTHON_PREFIX}/lib/python2.7/site-packages:${PYTHON_PREFIX}/lib)

# Update our bin PATH variable to include the python bin path
# (Important for Mac OS X, which uses a special python prefix.  See above)
set (BUILDEM_BIN_PATH ${PYTHON_PREFIX}/bin:${BUILDEM_BIN_PATH})

# Append our revised bin PATH variable to ENV string.
# (This means that PATH will be specified TWICE in the env string, but the second one takes precedence.)
set (BUILDEM_ENV_STRING   env ${BUILDEM_ENV_STRING} PATH=${BUILDEM_BIN_PATH})

set_target_properties(${python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python_NAME)
