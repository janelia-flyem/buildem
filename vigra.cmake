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

if (NOT DISABLE_VIGRANUMPY)
    include (numpy)
    set(NUMPY_DEP ${numpy_NAME})
    set(WITH_VIGRANUMPY "TRUE")
else()
    set(NUMPY_DEP "")
    set(WITH_VIGRANUMPY "FALSE")
endif()

include (nose)

# select the desired VIGRA commit
set(DEFAULT_VIGRA_VERSION "fb83cf8a595a36285980bd563c90e5d666bce388") # from 2014-06-23
IF(NOT DEFINED VIGRA_VERSION)
    SET(VIGRA_VERSION "${DEFAULT_VIGRA_VERSION}")
ENDIF()
SET(VIGRA_VERSION ${VIGRA_VERSION}
    CACHE STRING "Specify VIGRA branch/tag/commit to be used (default: ${DEFAULT_VIGRA_VERSION})"
    FORCE)

external_git_repo (vigra
    ${VIGRA_VERSION}
    https://github.com/ukoethe/vigra)
    
if("${VIGRA_VERSION}" STREQUAL "master")
    set(VIGRA_UPDATE_COMMAND git checkout master && git pull)
else()
    set(VIGRA_UPDATE_COMMAND git fetch origin && git checkout ${VIGRA_VERSION})
endif()

 
if (APPLE)
	set (DEFAULT_VIGRA_WITH_BOOST_THREAD 1)
else()
	set (DEFAULT_VIGRA_WITH_BOOST_THREAD 0)
endif()
set(VIGRA_WITH_BOOST_THREAD ${DEFAULT_VIGRA_WITH_BOOST_THREAD} 
	CACHE BOOL "Build Vigra with boost-thread instead of std c++11 thread")
set(VIGRA_THREAD_SETTING "-DWITH_BOOST_THREAD=${VIGRA_WITH_BOOST_THREAD}")

message ("Installing ${vigra_NAME}/${VIGRA_VERSION} into FlyEM build area: ${BUILDEM_DIR} ...")
message ("**********************************************************************************")
message ("***** WARNING: vigra test step SKIPPED for now.  Edit vigra.cmake to change. *****")
message ("**********************************************************************************")
ExternalProject_Add(${vigra_NAME}
    DEPENDS             ${libjpeg_NAME} ${libtiff_NAME} ${libpng_NAME} ${openexr_NAME} ${libfftw_NAME}
    ${hdf5_NAME} ${python_NAME} ${boost_NAME} ${NUMPY_DEP} ${nose_NAME} 
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${vigra_URL}
    GIT_TAG             ${vigra_TAG}
    #URL                 ${vigra_URL}
    #URL_MD5             ${vigra_MD5}
    UPDATE_COMMAND      ${VIGRA_UPDATE_COMMAND}
    PATCH_COMMAND       ""       
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        
        ${VIGRA_THREAD_SETTING}

        -DWITH_VIGRANUMPY=${WITH_VIGRANUMPY}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}

        -DBoost_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DBoost_LIBRARY_DIRS=${BUILDEM_DIR}/lib
        -DBoost_PYTHON_LIBRARY=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DBoost_PYTHON_LIBRARY_RELEASE=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DBoost_PYTHON_LIBRARY_DEBUG=${BUILDEM_DIR}/lib/libboost_python-mt.${BUILDEM_PLATFORM_DYLIB_EXTENSION}

        -DPYTHON_EXECUTABLE=${PYTHON_EXE}
        -DPYTHON_INCLUDE_PATH=${PYTHON_PREFIX}/include
        -DPYTHON_LIBRARIES=${PYTHON_PREFIX}/lib/libpython.2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DPYTHON_NUMPY_INCLUDE_DIR=${PYTHON_PREFIX}/lib/python2.7/site-packages/numpy/core/include
        -DPYTHON_SPHINX=${PYTHON_PREFIX}/bin/sphinx-build

        -DVIGRANUMPY_LIBRARIES=${PYTHON_PREFIX}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_python.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_thread.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_system.${BUILDEM_PLATFORM_DYLIB_EXTENSION}^^${BUILDEM_DIR}/lib/libboost_container.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DVIGRANUMPY_INSTALL_DIR=${PYTHON_PREFIX}/lib/python2.7/site-packages

        -DPNG_LIBRARY=${BUILDEM_DIR}/lib/libpng.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DPNG_PNG_INCLUDE_DIR=${BUILDEM_DIR}/include

        -DTIFF_LIBRARY=${BUILDEM_DIR}/lib/libtiff.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DTIFF_INCLUDE_DIR=${BUILDEM_DIR}/include

        -DJPEG_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DJPEG_LIBRARY=${BUILDEM_DIR}/lib/libjpeg.${BUILDEM_PLATFORM_DYLIB_EXTENSION}

        -DHDF5_CORE_LIBRARY=${BUILDEM_DIR}/lib/libhdf5.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_HL_LIBRARY=${BUILDEM_DIR}/lib/libhdf5_hl.${BUILDEM_PLATFORM_DYLIB_EXTENSION}
        -DHDF5_INCLUDE_DIR=${BUILDEM_DIR}/include
        
        -DZLIB_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DZLIB_LIBRARY=${BUILDEM_DIR}/lib/libz.${BUILDEM_PLATFORM_DYLIB_EXTENSION}

        -DFFTW3F_INCLUDE_DIR=
        -DFFTW3F_LIBRARY=
        -DFFTW3_INCLUDE_DIR=${BUILDEM_DIR}/include
        -DFFTW3_LIBRARY=${BUILDEM_DIR}/lib/libfftw3.${BUILDEM_PLATFORM_DYLIB_EXTENSION}

        -DCMAKE_CXX_FLAGS=-pthread
        -DCMAKE_CXX_LINK_FLAGS=-pthread
        -DCMAKE_CXX_FLAGS_RELEASE=-O2\ -DNDEBUG # Some versions of gcc miscompile vigra at -O3
        -DCMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG}"
        
        
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${vigra_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)
set (vigra_LIB   ${BUILDEM_LIB_DIR}/libvigraimpex.so)

endif (NOT vigra_NAME)

