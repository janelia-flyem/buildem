#
# install libxml2 from source
#

if (NOT libxml2_NAME)

  CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

  include (ExternalProject)
  include (ExternalSource)
  include (BuildeSupport)

  external_source(
    libxml2
    2.9.1
    libxml2-2.9.1.tar.gz
    9c0cfef285d5c4a5c80d00904ddab380
    ftp://xmlsoft.org/libxml2
    )

  message("Installing ${libxml2_NAME} into FlyEM build area ${BUILDEM_DIR} ...")
  ExternalProject_Add(
    ${libxml2_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${libxml2_URL}
    URL_MD5             ${libxml2_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${libxml2_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --enable-shared
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make check


  endif(NOT libxml2_NAME)
  