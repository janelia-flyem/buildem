#
# Install libjpeg from source
#

if (NOT libjpeg_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (libjpeg
    8d
    jpegsrc.v8d.tar.gz
    52654eb3b2e60c35731ea8fc87f1bd29
    http://www.ijg.org/files)

message ("Installing ${libjpeg_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libjpeg_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libjpeg_URL}
    URL_MD5             ${libjpeg_MD5}
    UPDATE_COMMAND      ${CMAKE_COMMAND} -E make_directory ${BUILDEM_DIR}/man/man1
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) LIBTOOL=./libtool # Must use the libtool that is built in place by the libjpeg Makfile (not the system libtool!)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make LIBTOOL=./libtool install
)

set_target_properties(${libjpeg_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libjpeg_NAME)
