#
# Install freetype2 from source
#

if (NOT freetype2_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

# TODO -- The download URL might only be valid for most recent release.
#   Find better mirror that has steady download URL or cache it at janelia.
external_source (freetype2
    2.4.10
    freetype-2.4.10.tar.bz2
    13286702e9390a91661f980608adaff1
    http://downloads.sourceforge.net/project/freetype/freetype2/2.4.10)

message ("Installing ${freetype2_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${freetype2_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${freetype2_URL}
    URL_MD5             ${freetype2_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${freetype_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT freetype2_NAME)