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
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
                        # These patches are the result of smashing all of the patches from ( ftp://ftp.gnu.org/pub/gnu/readline/readline-6.2-patches/ ) into one massive patch.
                        # Then, they have been split out to have one patch per file changed.
                        ${readline_SRC_DIR}/callback.c ${PATCH_DIR}/readline-6.2-callback.patch
                        ${readline_SRC_DIR}/input.c ${PATCH_DIR}/readline-6.2-input.patch
                        ${readline_SRC_DIR}/patchlevel ${PATCH_DIR}/readline-6.2-patchlevel.patch
                        ${readline_SRC_DIR}/support/shobj-conf ${PATCH_DIR}/readline-6.2-shobj-conf.patch
                        ${readline_SRC_DIR}/vi_mode.c ${PATCH_DIR}/readline-6.2-vi_mode.patch
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
