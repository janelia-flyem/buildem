#
# Install atlas from source
#

if (NOT atlas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_source (lapack
    3.4.2
    lapack-3.4.2.tgz
    http://www.netlib.org/lapack)

message ("Downloading ${lapack_NAME} tarball into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${lapack_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${lapack_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   "" 
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

external_source (atlas
    3.10.0
    atlas3.10.0.tar.bz2
    http://downloads.sourceforge.net/project/math-atlas/Stable/3.10.0)

message ("Installing ${atlas_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${atlas_NAME}
    DEPENDS             ${lapack_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${atlas_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${atlas_SRC_DIR}/configure -b 64 --shared --prefix=${FLYEM_BUILD_DIR} --with-netlib-lapack-tarfile=${lapack_FILE}
    BUILD_COMMAND       make
    TEST_COMMAND        make check
    INSTALL_COMMAND     make install
)

endif (NOT atlas_NAME)