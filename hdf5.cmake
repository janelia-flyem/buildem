#
# Install hdf5 library from source
#

if (NOT hdf5_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (zlib)

external_source (hdf5
    1.8.9
    hdf5-1.8.9.tar.gz
    d1266bb7416ef089400a15cc7c963218
    http://www.hdfgroup.org/ftp/HDF5/current/src)

message ("Installing ${hdf5_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${hdf5_NAME}
    DEPENDS                 ${zlib_NAME}
    PREFIX                  ${FLYEM_BUILD_DIR}
    URL                     ${hdf5_URL}
    URL_MD5                 ${hdf5_MD5}
    UPDATE_COMMAND          ""
    PATCH_COMMAND           ${FLYEM_ENV_STRING} ${PATCH_EXE}
        ${hdf5_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/hdf5-1.patch
    CONFIGURE_COMMAND       ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} ${hdf5_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${FLYEM_BUILD_DIR}
        -DCMAKE_PREFIX_PATH=${FLYEM_BUILD_DIR}
        -DHDF5_BUILD_HL_LIB=ON
        -DHDF_BUILD_CPP_LIB=ON
        -DBUILD_SHARED_LIBS=ON
        -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
#        -DBUILD_TESTING=ON
    BUILD_COMMAND           ${FLYEM_ENV_STRING} make
#    TEST_COMMAND        make check
    INSTALL_COMMAND         ${FLYEM_ENV_STRING} make install
)

endif (NOT hdf5_NAME)