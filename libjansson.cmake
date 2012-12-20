#
# Install libjansson from source
#

if (NOT libjansson_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_git_repo (libjansson
  HEAD
  https://github.com/akheron/jansson.git
  )

message ("Installing ${libjansson_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${libjansson_NAME}
    PREFIX              ${BUILDEM_DIR}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND ${BUILDEM_ENV_STRING} ./configure 
        --prefix=${BUILDEM_DIR}

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    BUILD_IN_SOURCE     1 # Configure script reqiures BUILD_IN_SOURCE
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

endif (NOT libjansson_NAME)
