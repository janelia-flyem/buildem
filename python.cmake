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
include (PatchSupport)

include (zlib)
include (openssl)   # without openssl, hashlib might have missing encryption methods
include (readline)  # To support the readline module.
include (sqlite)    # required to implement the standard module sqlite3
                    # (https://docs.python.org/2/library/sqlite3.html)

external_source (python
    2.7.6
    Python-2.7.6.tgz
    1d8728eb0dfcac72a0fd99c17ec7f386
    http://www.python.org/ftp/python/2.7.6)

message ("Installing ${python_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac, we build a "Framework" build which has all the power of a "normal" build, 
    #  plus it can be used from a native GUI.
    # See http://svn.python.org/projects/python/trunk/Mac/README
    set (PYTHON_BINARY_TYPE_ARG "--enable-framework=${BUILDEM_DIR}/Frameworks")
    set (PYTHON_PREFIX ${BUILDEM_DIR}/Frameworks/Python.framework/Versions/2.7)
else()
    # On linux, PYTHON_PREFIX is the same as the general prefix.
    set (PYTHON_BINARY_TYPE_ARG "--enable-shared")
    set (PYTHON_PREFIX ${BUILDEM_DIR})
endif()

set (PYTHON_BUILD_DEBUG "FALSE" CACHE BOOL "Configure Python --with-pydebug and --without-pymalloc for debugging extensions with gdb.")

if (${PYTHON_BUILD_DEBUG})
    # If you want to debug python with gdb, you need --with-pydebug.
    # Also, --without-pymalloc is useful if you want to avoid assertions in PyMalloc
    #  that can be caused by some python extensions (e.g. the python vtk bindings hit those assertions)
    # Of course, if those assertions are hit by code that YOU wrote, then you might 
    #  want to change this build command so you can debug WITH pymalloc.
    set(PYTHON_DEBUG_CONFIG_ARGS "--with-pydebug=yes --with-pymalloc=no")
endif()

ExternalProject_Add(${python_NAME}
    DEPENDS             ${zlib_NAME} ${openssl_NAME} ${readline_NAME} ${sqlite_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${python_URL}
    URL_MD5             ${python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
			# This patch stops including the system Python site-packages on Python.
                        # Without this patch buildem versions of Python tools will either not be installed
                        # or not be used. This will give the false sense that something succeeded in buildem.
			${python_SRC_DIR}/Lib/site.py ${PATCH_DIR}/turn_off_mac_sys_path.patch
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${python_SRC_DIR}/configure 
        --prefix=${BUILDEM_DIR}
        ${PYTHON_BINARY_TYPE_ARG}
        ${PYTHON_DEBUG_CONFIG_ARGS}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) -j1  # Fails on Mavericks when multithreaded.
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
