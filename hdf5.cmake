#
# Install hdf5 library from source
#

if (NOT hdf5_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PatchSupport)

include (zlib)

external_source (hdf5
    1.8.9
    hdf5-1.8.9.tar.gz
    http://www.hdfgroup.org/ftp/HDF5/current/src)

message ("Installing ${hdf5_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${hdf5_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${hdf5_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE}
        ${hdf5_SRC_DIR}/CMakeLists.txt ${PATCH_DIR}/hdf5-1.patch
    CONFIGURE_COMMAND   ${CMAKE_COMMAND} ${hdf5_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX:string=${FLYEM_BUILD_DIR}
        -DCMAKE_FIND_ROOT_PATH=${FLYEM_BUILD_DIR}
        -DHDF5_BUILD_HL_LIB=ON
        -DHDF_BUILD_CPP_LIB=ON
        -DBUILD_SHARED_LIBS=ON
#        -DBUILD_TESTING=ON
    BUILD_COMMAND       make
#    TEST_COMMAND        make check
    INSTALL_COMMAND     make install
)

endif (NOT hdf5_NAME)