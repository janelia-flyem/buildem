#
# Install golang from source
#

if (NOT golang_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (golang
    1.0.3
    go1.0.3.src.tar.gz
    31acddba58b4592242a3c3c16165866b
    http://go.googlecode.com/files)

message ("Installing ${golang_NAME} into build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${golang_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${golang_URL}
    URL_MD5           ${golang_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} GOBIN=${BUILDEM_BIN_DIR} ./all.bash
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ""
)

set_target_properties(${golang_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT golang_NAME)