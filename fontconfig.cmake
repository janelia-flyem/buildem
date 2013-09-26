#
# install fontconfig from source
#

if (NOT fontconfig_NAME)

  CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
  
  include (ExternalProject)
  include (ExternalSource)
  include (BuildeSupport)

  external_source(
    fontconfig
    2.10.95
    fontconfig-2.10.95.tar.gz
    09bb3c3469c3453d4d5c39f66f8a8aac
    http://www.freedesktop.org/software/fontconfig/release/
    )

  message("Installing ${fontconfig_NAME} into FlyEM build area ${BUILDEM_DIR} ...")
  ExternalProject_Add(
    ${fontconfig_NAME}
    DEPENDS             ${libxml2_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${fontconfig_URL}
    URL_MD5             ${fontconfig_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${fontconfig_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --enable-shared
        --enable-libxml2
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check


  endif(NOT fontconfig_NAME)