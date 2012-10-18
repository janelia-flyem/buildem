#
# Install boost libraries from source
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

#external_source (vigra
#    1.8.0
#    vigra-1.8.0-src.tar.gz
#    15c5544448e529ee60020758ab6be264
#    http://hci.iwr.uni-heidelberg.de/vigra)

external_source (vigra
    flyem-1.7.1
    vigra-flyem-1.7.1.tar.gz
    7325a6fed78383807fd553fc5ee30190)

# Note the number of forced -D CMake variable sets in the configure.
# There is trouble making vigra find the libraries given priority in 
# CMAKE_FIND_ROOT_PATH and even using DEPENDENCY_SEARCH_PREFIX.  
# Therefore, the problem libraries are set specifically.
message ("Installing ${vigra_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${vigra_NAME}
    DEPENDS             ${libjpeg_NAME} ${libtiff_NAME} ${libpng_NAME} ${openexr_NAME} ${libfftw_NAME}
                        ${hdf5_NAME} ${python_NAME} ${boost_NAME} ${numpy_NAME} 
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${vigra_URL}
    URL_MD5             ${vigra_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} ${vigra_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=-L${FLYEM_BUILD_DIR}/lib,-Wl,-rpath=${FLYEM_BUILD_DIR}/lib
        -DDEPENDENCY_SEARCH_PREFIX=${FLYEM_BUILD_DIR}
        -DBoost_LIBRARY_DIRS=${FLYEM_BUILD_DIR}/lib
        -DBoost_PYTHON_LIBRARY=${FLYEM_BUILD_DIR}/lib/libboost_python.so
        -DBoost_PYTHON_LIBRARY_RELEASE=${FLYEM_BUILD_DIR}/lib/libboost_python.so
        -DBoost_PYTHON_LIBRARY_DEBUG=${FLYEM_BUILD_DIR}/lib/libboost_python.so
        -DVIGRANUMPY_LIBRARIES=${FLYEM_BUILD_DIR}/lib/libpython2.7.so:${FLYEM_BUILD_DIR}/lib/libboost_python.so
        -DJPEG_INCLUDE_DIR=${FLYEM_BUILD_DIR}/include
        -DJPEG_LIBRARY=${FLYEM_BUILD_DIR}/lib/libjpeg.so
        -DHDF5_CORE_LIBRARY=${FLYEM_BUILD_DIR}/lib/libhdf5.so
        -DHDF5_HL_LIBRARY=${FLYEM_BUILD_DIR}/lib/libhdf5_hl.so
        -DHDF5_INCLUDE_DIR=${FLYEM_BUILD_DIR}/include
        -DFFTW3F_INCLUDE_DIR=
        -DFFTW3F_LIBRARY=
        -DFFTW3_INCLUDE_DIR=${FLYEM_BUILD_DIR}/include
        -DFFTW3_LIBRARY=${FLYEM_BUILD_DIR}/lib/libfftw3.so
        -DCMAKE_CXX_FLAGS=-pthread
        -DCMAKE_CXX_LINK_FLAGS=-pthread
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    TEST_COMMAND        ${FLYEM_ENV_STRING} make check
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT vigra_NAME)

