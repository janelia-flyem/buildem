#
# Install the JsonCpp program into an OS-specific build directory
#

if (NOT libcurl_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

SET(LIBCURL_VERSION "787c2ae91b1f172ce9fdd2b6613c6217c00a85b3")

external_git_repo (libcurl
    ${LIBCURL_VERSION}
    https://github.com/bagder/curl)
    

# Download libcurl and build it.
message ("Installing ${libcurl_NAME} ...")
ExternalProject_Add(${libcurl_NAME}
    DEPENDS             ""
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${libcurl_URL}
    GIT_TAG             ${libcurl_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${libcurl_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}
        -DCMAKE_CXX_FLAGS_RELEASE=-O3
        -DCMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) 
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${libcurl_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT libcurl_NAME)
