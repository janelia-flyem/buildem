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

message ("Installing ${libjpeg_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${libjpeg_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${libjpeg_URL}
    URL_MD5             ${libjpeg_MD5}
    LIST_SEPARATOR      ^^
    UPDATE_COMMAND      ${CMAKE_COMMAND} -E make_directory ${FLYEM_BUILD_DIR}/man/man1
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ./configure 
        --prefix=${FLYEM_BUILD_DIR} 
        --enable-shared
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib^^-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make LIBTOOL=libtool
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${FLYEM_ENV_STRING} make check
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make LIBTOOL=libtool install
)

endif (NOT libjpeg_NAME)