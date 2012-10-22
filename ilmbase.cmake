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

message ("Installing ${ilmbase_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${ilmbase_NAME}
    DEPENDS             ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${ilmbase_URL}
    URL_MD5             ${ilmbase_MD5}
    LIST_SEPARATOR      ^^
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${PATCH_EXE}
        ${ilmbase_SRC_DIR}/Imath/ImathMatrix.h ${PATCH_DIR}/ilmbase-1.patch
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${ilmbase_SRC_DIR}/configure 
        --prefix=${FLYEM_BUILD_DIR}
        LDFLAGS=-Wl,-rpath,${FLYEM_BUILD_DIR}/lib^^-L${FLYEM_BUILD_DIR}/lib
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT ilmbase_NAME)