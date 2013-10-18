#
# Install ilmbase from source
#

if (NOT ilmbase_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (zlib)

external_source (ilmbase
    1.0.2
    ilmbase-1.0.2.tar.gz
    26c133ee8ca48e1196fbfb3ffe292ab4
    http://download.savannah.nongnu.org/releases/openexr)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(ilmbase_PATCH_COMMAND ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch
        # Add extra patch for clang compatibility
        ${ilmbase_SRC_DIR}/configure ${PATCH_DIR}/ilmbase-clang.patch )
else()
    set(ilmbase_PATCH_COMMAND ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch )
endif()

message ("Installing ${ilmbase_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${ilmbase_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${ilmbase_URL}
    URL_MD5             ${ilmbase_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${ilmbase_PATCH_COMMAND}
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${ilmbase_SRC_DIR}/configure 
        --prefix=${BUILDEM_DIR}
        LDFLAGS=${BUILDEM_LDFLAGS}
        CPPFLAGS=-I${BUILDEM_DIR}/include
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${ilmbase_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ilmbase_NAME)