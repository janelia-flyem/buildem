#
# Install vigra libraries from source
#

if (NOT vigra_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (libjpeg)
include (libtiff)
include (libpng)
include (openexr)
include (libfftw)
include (hdf5)
include (python)
include (boost)
include (numpy)
include (nose)

# select the desired VIGRA commit
set(DEFAULT_VIGRA_VERSION "fd5d9bf7")
IF(NOT DEFINED VIGRA_VERSION)
    SET(VIGRA_VERSION "${DEFAULT_VIGRA_VERSION}")
ENDIF()
SET(VIGRA_VERSION ${VIGRA_VERSION}
    CACHE STRING "Specify VIGRA branch/tag/commit to be used (default: ${DEFAULT_VIGRA_VERSION})"
    FORCE)

external_git_repo (vigra
    ${VIGRA_VERSION}
    http://github.com/ukoethe/vigra
    vigra) # Override vigra_NAME and vigra_SRC_DIR variables by providing this extra arg

if("${VIGRA_VERSION}" STREQUAL "master")
    set(VIGRA_UPDATE_COMMAND git checkout master && git pull)
else()
    set(VIGRA_UPDATE_COMMAND git checkout ${VIGRA_VERSION})
endif()

message ("Installing ${vigra_NAME}/${VIGRA_VERSION} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${vigra_NAME}
    DEPENDS             ${libjpeg_NAME} ${libtiff_NAME} ${libpng_NAME} ${openexr_NAME} ${libfftw_NAME}
                        ${hdf5_NAME} ${python_NAME} ${boost_NAME} ${numpy_NAME} ${nose_NAME} 
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${vigra_URL}
    #URL                 ${vigra_URL}
    #URL_MD5             ${vigra_MD5}
    UPDATE_COMMAND      ${VIGRA_UPDATE_COMMAND}
    PATCH_COMMAND       ""       
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}
        -DBoost_LIBRARY_DIRS=${BUILDEM_DIR}/lib
 #       -DBoost_PYTHON_LIBRARY=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DBoost_PYTHON_LIBRARY_RELEASE=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DBoost_PYTHON_LIBRARY_DEBUG=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
 #       -DVIGRANUMPY_LIBRARIES=${BUILDEM_DIR}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_python.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DJPEG_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DJPEG_LIBRARY=${BUILDEM_DIR}/lib/libjpeg.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_CORE_LIBRARY=${BUILDEM_DIR}/lib/libhdf5.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_HL_LIBRARY=${BUILDEM_DIR}/lib/libhdf5_hl.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DFFTW3F_INCLUDE_DIR=
        -DFFTW3F_LIBRARY=
        -DFFTW3_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DFFTW3_LIBRARY=${BUILDEM_DIR}/lib/libfftw3.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DCMAKE_CXX_FLAGS=-pthread
        -DCMAKE_CXX_LINK_FLAGS=-pthread
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${vigra_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set (vigra_LIB   ${BUILDEM_LIB_DIR}/libvigraimpex.so)

endif (NOT vigra_NAME)

