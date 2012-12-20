#
# Install libjansson from source
#

if (NOT libjansson_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source(libjansson
  2.4
  jansson-2.4.tar.gz
  http://www.digip.org/jansson/releases
  )

message ("Installing ${libjansson_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libjansson_NAME}
    PREFIX              ${BUILDEM_DIR}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND ${BUILDEM_ENV_STRING} ${libjansson_SRC_DIR}/configure --prefix=${BUILDEM_DIR} --enable-shared
    GIT_REPOSITORY      ${libjansson_URL}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

endif (NOT libjansson_NAME)
