# A standard asynchronous message passing library.
# Required by pyzmq, which is used by iPython.

if (NOT zeromq_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (zeromq
    3.2.4
    zeromq-3.2.4.tar.gz
    39af2d41e3fb744b98d7999e291e05dc
    http://download.zeromq.org/)

message ("Installing ${zeromq_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${zeromq_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${zeromq_URL}
    URL_MD5             ${zeromq_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ./configure --prefix ${BUILDEM_DIR}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${zeromq_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT zeromq_NAME)