#
# Install glfw from source
#

if (NOT glfw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (glfw
    2.7.7
    glfw-2.7.7.tar.gz
    8b97c1d6366e20f5c082d8b631b945d7
    http://downloads.sourceforge.net/project/glfw/glfw/2.7.7)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set (MAKE_PLATFORM "Cocoa")
elseif (${UNIX})
    set (MAKE_PLATFORM "x11")
else ()
    message (FATAL_ERROR "Can't determine current system to build GLFW")
endif ()

message ("Installing ${glfw_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${glfw_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${glfw_URL}
    URL_MD5             ${glfw_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make ${MAKE_PLATFORM}
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} PREFIX=${BUILDEM_DIR} make ${MAKE_PLATFORM}-dist-install
)

set_target_properties(${glfw_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

# If we also want to include static libraries, use "make x11-install" without the "dist"

endif (NOT glfw_NAME)