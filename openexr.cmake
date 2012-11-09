#
# Install openexr from source
#

if (NOT openexr_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (PkgConfig)
include (BuildSupport)
include (PatchSupport)

include (ilmbase)
include (zlib)

external_source (openexr
    1.6.1
    openexr-1.6.1.tar.gz
    11951f164f9c872b183df75e66de145a
    http://download.savannah.nongnu.org/releases/openexr)

if (${CMAKE_CXX_COMPILER_ID} MATCHES ".*Clang.*")
    set(openexr_PATCH_COMMAND ${FLYEM_ENV_STRING} ${PATCH_EXE}
        ${openexr_SRC_DIR}/exrmaketiled/main.cpp ${PATCH_DIR}/openexr-exrmaketiled.patch
        ${openexr_SRC_DIR}/exrenvmap/main.cpp ${PATCH_DIR}/openexr-exrenvmap.patch
        # Add extra patch for clang compatibility
        ${openexr_SRC_DIR}/configure ${PATCH_DIR}/openexr-clang.patch )
else()
    set(openexr_PATCH_COMMAND ${FLYEM_ENV_STRING} ${PATCH_EXE}
        ${openexr_SRC_DIR}/exrmaketiled/main.cpp ${PATCH_DIR}/openexr-exrmaketiled.patch
        ${openexr_SRC_DIR}/exrenvmap/main.cpp ${PATCH_DIR}/openexr-exrenvmap.patch )
endif()

message ("Installing ${openexr_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${openexr_NAME}
    DEPENDS             ${ilmbase_NAME} ${zlib_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${openexr_URL}
    URL_MD5             ${openexr_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${openexr_PATCH_COMMAND}
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${openexr_SRC_DIR}/configure
        --prefix=${FLYEM_BUILD_DIR}
        --disable-ilmbasetest
        PKG_CONFIG_PATH=${FLYEM_PKGCONFIG_DIR}
        LDFLAGS=${FLYEM_LDFLAGS}
        CPPFLAGS=-I${FLYEM_BUILD_DIR}/include
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
)

endif (NOT openexr_NAME)