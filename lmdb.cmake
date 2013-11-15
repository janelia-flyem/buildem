#
# Install Lightning MDB from snapshotted tarball
#

if (NOT lmdb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PkgConfig)
include (BuildSupport)

external_source (lmdb
    0.9.10
    lmdb-0.9.10.tar.gz
    313e5015517e7183d5e85ba72293719c)

message ("Installing ${lmdb_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${lmdb_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${lmdb_URL}
    URL_MD5             ${lmdb_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_IN_SOURCE     1
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install prefix=${BUILDEM_DIR} -i
)

set_target_properties(${lmdb_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lmdb_NAME)