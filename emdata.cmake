if (NOT emdata_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (BuildSupport)
include (ExternalSource)

include (gtest)
include (leveldb)
include (thrift)
include (python)
include (setuptools)

set (emdata_DEPENDENCIES
     ${python_NAME} ${setuptools_NAME} ${gtest_NAME} ${leveldb_NAME} ${thrift_NAME})

external_git_repo (emdata
    HEAD
    http://github.com/janelia-flyem/emdata.git)

set (emdata_INCLUDE_DIR ${BUILDEM_INCLUDE_DIR}/emdata)
include_directories (${emdata_INCLUDE_DIR})

message ("Installing ${emdata_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${emdata_NAME}
    DEPENDS             ${emdata_DEPENDENCIES}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${emdata_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} -DBUILDEM_DIR=${BUILDEM_DIR} ${emdata_SRC_DIR}
    BUILD_COMMAND       make
    TEST_COMMAND        ${BUILDEM_ENV_STRING} ${BUILDEM_TEST_DIR}/test_encoder
    INSTALL_COMMAND     ""
)

set_target_properties(${emdata_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT emdata_NAME)
