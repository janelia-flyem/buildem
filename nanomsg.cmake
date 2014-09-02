#
# Install nanomsg from source
#

if (NOT nanomsg_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (nanomsg
    0.4
    nanomsg-0.4-beta.tar.gz
    374dca0a9c0ca1403f2a920400acc33e
    http://download.nanomsg.org)

message ("Installing ${nanomsg_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${APPLE})
    message ("nanomsg install: Detected Apple platform.")
	set (LIBFILE "dylib")
elseif (${UNIX})
    message ("nanomsg install: Detected UNIX-like platform.")
	set (LIBFILE "so")
# set (COMPILE_FLAGS "-lrt")
elseif (${WINDOWS})
    message (FATAL_ERROR "Detected Windows platform.  No nanomsg setup for it yet!")
endif ()

ExternalProject_Add(${nanomsg_NAME}
    PREFIX            ${BUILDEM_DIR}
    URL               ${nanomsg_URL}
    URL_MD5           ${nanomsg_MD5}
    UPDATE_COMMAND    ""
    PATCH_COMMAND     ""
    CONFIGURE_COMMAND ./configure 
        --prefix=${BUILDEM_DIR} 
        --enable-shared
        --enable-static
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE   1
    INSTALL_COMMAND   ${BUILDEM_ENV_STRING} $(MAKE) install

# BUILD_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) ${COMPILE_FLAGS}
#    INSTALL_COMMAND   ${CMAKE_COMMAND} -E copy 
#        ${nanomsg_SRC_DIR}/libnanomsg.${LIBFILE}.${nanomsg_RELEASE} ${BUILDEM_LIB_DIR}/libnanomsg.${LIBFILE}
)

set_target_properties(${nanomsg_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

set (nanomsg_STATIC_LIBRARIES ${BUILDEM_LIB_DIR}/libnanomsg.a)

endif (NOT nanomsg_NAME)
