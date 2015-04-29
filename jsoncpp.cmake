#
# Install the JsonCpp program into an OS-specific build directory
#

if (NOT jsoncpp_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

SET(JSONCPP_VERSION "cbe7e7c9cbd39d864588c5cf2436690634562d3f")

external_git_repo (jsoncpp
    ${JSONCPP_VERSION}
    http://github.com/open-source-parsers/jsoncpp)
    

# Download jsoncpp and build it.
message ("Installing ${jsoncpp_NAME} ...")
ExternalProject_Add(${jsoncpp_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${jsoncpp_URL}
    GIT_TAG             ${jsoncpp_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${jsoncpp_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}
        -DJSONCPP_LIB_BUILD_SHARED=ON 
        -DCMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) 
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${jsoncpp_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (json_LIB ${BUILDEM_DIR}/lib/libjsoncpp.so)
set (json_INCLUDES ${BUILDEM_DIR}/include)

message ("Including JSON include files from here: ${json_INCLUDES}")

endif (NOT jsoncpp_NAME)
