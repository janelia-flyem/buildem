#
# Install readline from source.
#

if (NOT readline_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (readline
    6.2
    readline-6.2.tar.gz
    67948acb2ca081f23359d0256e9a271c
    ftp://ftp.gnu.org/gnu/readline)

message ("Installing ${readline_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${readline_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${readline_URL}
    URL_MD5             ${readline_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${readline_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        --enable-shared
        --enable-static
        "LDFLAGS=${BUILDEM_LDFLAGS} ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
        "CPPFLAGS=-I${BUILDEM_DIR}/include ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${readline_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT readline_NAME)
