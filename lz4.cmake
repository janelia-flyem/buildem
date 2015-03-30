#
# Install the lz4 library into an OS-specific build directory
#

if (NOT lz4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

SET(LZ4_VERSION "e25b51de7b51101e04ceea194dd557fcc23c03ca")

external_git_repo (lz4
    ${LZ4_VERSION}
    https://github.com/Cyan4973/lz4)

# Download lz4 and build it.
message ("Installing ${lz4_NAME} ...")
ExternalProject_Add(${lz4_NAME}
    DEPENDS             ""
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${lz4_URL}
    GIT_TAG             ${lz4_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   "" 
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1 
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} PREFIX=${BUILDEM_DIR} $(MAKE) install
)

set_target_properties(${lz4_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lz4_NAME)
