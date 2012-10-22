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

message ("Installing ${freetype2_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${freetype2_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${freetype2_URL}
    URL_MD5             ${freetype2_MD5}
    LINE_SEPARATOR      ^^
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix=${FLYEM_BUILD_DIR} 
        --enable-shared
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib^^-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT freetype2_NAME)