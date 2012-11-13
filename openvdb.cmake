#
# Install openvdb from source
#

if (NOT openvdb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PkgConfig)
include (BuildSupport)

include (boost)
include (cppunit)
include (zlib)
include (openexr)
include (tbb)
include (doxygen)
include (glfw)

external_source (openvdb
    0.97.0
    openvdb_0_97_0_library.tgz
    2b15d03a9654ea40d138dc6e17729eb6
    http://www.openvdb.org/download)

set (OPENVDB_VALUES
    INSTALL_DIR=${FLYEM_BUILD_DIR}
    CPPUNIT_INCL_DIR=${FLYEM_BUILD_DIR}/include
    CPPUNIT_LIB_DIR=${FLYEM_BUILD_DIR}/lib
    CPPUNIT_LIB=-lcppunit\ -lboost_system
    BOOST_INCL_DIR=${FLYEM_BUILD_DIR}/include/boost
    HALF_INCL_DIR=${FLYEM_BUILD_DIR}/include
    HALF_LIB_DIR=${FLYEM_BUILD_DIR}/lib 
    TBB_INCL_DIR=${FLYEM_BUILD_DIR}/include
    TBB_LIB_DIR=${FLYEM_BUILD_DIR}/lib
    GFLW_INCL_DIR=${FLYEM_BUILD_DIR}/include/GL
    GFLW_LIB_DIR=${FLYEM_BUILD_DIR}/lib)

message ("Installing ${openvdb_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${openvdb_NAME}
    DEPENDS             ${boost_NAME} ${cppunit_NAME} ${zlib_NAME} ${openexr_NAME} 
                        ${tbb_NAME} ${doxygen_NAME} ${glfw}
    PREFIX              ${FLYEM_BUILD_DIR}
    SOURCE_DIR          ${FLYEM_BUILD_DIR}/src/openvdb  # Needed due to include paths
    URL                 ${openvdb_URL}
    URL_MD5             ${openvdb_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make ${OPENVDB_VALUES}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${FLYEM_ENV_STRING} make test
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install ${OPENVDB_VALUES}
)

endif (NOT openvdb_NAME)