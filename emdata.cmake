CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)
include (ExternalSource)

include (gtest)
include (leveldb)
include (thrift)
include (python)
include (setuptools)

external_git_repo (emdata
    HEAD
    http://github.com/janelia-flyem/emdata.git)

set (emdata_INCLUDE_DIR ${BUILDEM_INCLUDE_DIR}/emdata)
include_directories (${emdata_INCLUDE_DIR})

message ("Installing ${emdata_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${emdata_NAME}
    DEPENDS             ${gtest_NAME} ${leveldb_NAME} ${thrift_NAME} ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${emdata_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} -DBUILDEM_DIR=${BUILDEM_DIR} ${emdata_SRC_DIR}
    BUILD_COMMAND       make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} ${BUILDEM_TEST_DIR}/test_encoder
    INSTALL_COMMAND     ""
)
