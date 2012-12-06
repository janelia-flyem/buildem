#
# Install openvdb from source
#

if (NOT openvdb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PkgConfig)
include (BuildSupport)
include (PatchSupport)

include (boost)
include (cppunit)
include (zlib)
include (openexr)
include (tbb)
include (doxygen)
include (glfw)

external_source (openvdb
    0.99.0
    openvdb_0_99_0_library.tgz
    5aac825a3e42c26969f8c190ec5fd1a0
    http://www.openvdb.org/download)

set (OPENVDB_VALUES
    INSTALL_DIR=${BUILDEM_DIR}
    CPPUNIT_INCL_DIR=${BUILDEM_DIR}/include
    CPPUNIT_LIB_DIR=${BUILDEM_DIR}/lib
    CPPUNIT_LIB=-lcppunit\ -lboost_system
    BOOST_INCL_DIR=${BUILDEM_DIR}/include/boost
    HALF_INCL_DIR=${BUILDEM_DIR}/include
    HALF_LIB_DIR=${BUILDEM_DIR}/lib 
    TBB_INCL_DIR=${BUILDEM_DIR}/include
    TBB_LIB_DIR=${BUILDEM_DIR}/lib
    GFLW_INCL_DIR=${BUILDEM_DIR}/include/GL
    GFLW_LIB_DIR=${BUILDEM_DIR}/lib)

message ("Installing ${openvdb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openvdb_NAME}
    DEPENDS             ${boost_NAME} ${cppunit_NAME} ${zlib_NAME} ${openexr_NAME} 
                        ${tbb_NAME} ${doxygen_NAME} ${glfw_NAME}
    PREFIX              ${BUILDEM_DIR}
    SOURCE_DIR          ${BUILDEM_DIR}/src/openvdb  # Needed due to include paths
    URL                 ${openvdb_URL}
    URL_MD5             ${openvdb_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make ${OPENVDB_VALUES}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install ${OPENVDB_VALUES}
)

set_target_properties(${openvdb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openvdb_NAME)