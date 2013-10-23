#
# Install Lightning MDB from snapshotted tarball
#

if (NOT lmdb_NAME)

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

external_source (lmdb
    0.9.8
    lmdb-0.9.8.tar.gz
    834777d07442318e6a8a08b85c00833a)

message ("Installing ${lmdb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lmdb_NAME}
    DEPENDS             
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lmdb_URL}
    URL_MD5             ${lmdb_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install BUILDEM_DIR=$BUILDEM_DIR
)

set_target_properties(${lmdb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openvdb_NAME)