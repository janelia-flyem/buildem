#
# Install libjpeg from source
#

if (NOT libjpeg_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

# Need dos2unix because libjpeg source has dos lines that break under unix.
# include (dos2unix)

external_source (libjpeg
    8d
    jpegsrc.v8d.tar.gz
    http://www.ijg.org/files)

message ("Installing ${libjpeg_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libjpeg_NAME}
    DEPENDS           ${dos2unix_NAME}
    PREFIX            ${FLYEM_BUILD_DIR}
    URL               ${libjpeg_URL}
    UPDATE_COMMAND    ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/man/man1
#    PATCH_COMMAND     ${FLYEM_BUILD_DIR}/bin/dos2unix ${libjpeg_SRC_DIR}/configure
    CONFIGURE_COMMAND ./configure 
        --prefix=${FLYEM_BUILD_DIR} 
        --enable-shared
        LDFLAGS=-L${FLYEM_BUILD_DIR}/lib
    BUILD_COMMAND     make LIBTOOL=libtool
    BUILD_IN_SOURCE   1
    TEST_COMMAND      make check
    INSTALL_COMMAND   make LIBTOOL=libtool install
)

endif (NOT libjpeg_NAME)