#
# Install blockedarray libraries from source
#

if (NOT blockedarray_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (boost)
include (numpy)
include (vigra)

set(blockedarray_UPDATE_COMMAND git checkout master && git pull) 

external_git_repo (blockedarray
    HEAD
    https://github.com/thorbenk/blockedarray)

message ("Installing ${blockedarray_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${blockedarray_NAME}
    DEPENDS             ${python_NAME} ${boost_NAME} ${numpy_NAME} ${vigra_NAME} ${snappy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${blockedarray_URL}
    GIT_TAG             ${blockedarray_TAG}
    UPDATE_COMMAND      ${blockedarray_UPDATE_COMMAND}
    PATCH_COMMAND       ""       
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND}
    	-DCMAKE_BUILD_TYPE=Release
    	-DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DPYTHON_EXECUTABLE=${PYTHON_EXE}
        -DPYTHON_INCLUDE_DIR=${PYTHON_PREFIX}/include/python2.7
        "-DPYTHON_LIBRARY=${PYTHON_PREFIX}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}"
    	-DPYTHON_SITE_PACKAGES=${PYTHON_PREFIX}/lib/python2.7/site-packages
        -DBoost_LIBRARY_DIRS=${BUILDEM_DIR}/lib
    	${blockedarray_SRC_DIR}
    	
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    
    # blockedarray doesn't support a seperate install location.
    # Its output .so is copied directly into the source tree and used from there.
    ###INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    INSTALL_COMMAND     ""
)

endif (NOT blockedarray_NAME)

