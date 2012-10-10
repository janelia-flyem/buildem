#
# Install boost libraries from source
#

if (NOT vigra_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

include (libjpeg)
include (libtiff)
include (libpng)
include (openexr)
include (hdf5)
include (python)
include (boost)
#include (numpy)

external_source (vigra
    1.8.0
    vigra-1.8.0-src.tar.gz
    /tmp)
#    http://hci.iwr.uni-heidelberg.de/vigra)

# Note the number of forced -D CMake variable sets in the configure.
# There is trouble making vigra find the libraries given priority in 
# CMAKE_FIND_ROOT_PATH and even using DEPENDENCY_SEARCH_PREFIX.  
# Therefore, the problem libraries are set specifically.
message ("Installing ${vigra_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${vigra_NAME}
    DEPENDS ${libjpeg_NAME} ${libtiff_NAME} ${libpng_NAME} ${openexr_NAME} ${hdf5_NAME}
        ${python_NAME} ${boost_NAME}
    PREFIX ${FLYEM_BUILD_DIR}
    URL ${vigra_URL}
    UPDATE_COMMAND ""
    PATCH_COMMAND ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
        -DDEPENDENCY_SEARCH_PREFIX=${FLYEM_BUILD_DIR}
        -DJPEG_INCLUDE_DIR=${FLYEM_BUILD_DIR}/include
        -DJPEG_LIBRARY=${FLYEM_BUILD_DIR}/lib/libjpeg.so
        -DHDF5_CORE_LIBRARY=${FLYEM_BUILD_DIR}/lib/libhdf5.so
        -DHDF5_HL_LIBRARY=${FLYEM_BUILD_DIR}/lib/libhdf5_hl.so
        -DHDF5_INCLUDE_DIR=${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND     make
    TEST_COMMAND      make check
    INSTALL_COMMAND   make install
)

endif (NOT vigra_NAME)