#
# Install dos2unix from source
#

if (NOT dos2unix_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (dos2unix
    6.0.2
    dos2unix-6.0.2.tar.gz
    11ee6ae80c8acd6d750399cbf4ab6bd9
    http://downloads.sourceforge.net/project/dos2unix/dos2unix/6.0.2)

message ("Installing ${dos2unix_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${dos2unix_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${dos2unix_URL}
    URL_MD5             ${dos2unix_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make prefix=${FLYEM_BUILD_DIR}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make prefix=${FLYEM_BUILD_DIR} install
)

endif (NOT dos2unix_NAME)