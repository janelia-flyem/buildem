#
# Install geos from source.
# Provides an open source geometry engine.
#

if (NOT geos_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (geos
    3.4.2
    geos-3.4.2.tar.bz2
    fc5df2d926eb7e67f988a43a92683bae
    http://download.osgeo.org/geos/)


# if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
#     set (GEOS_ENABLE_MACOSX_FRAMEWORK ON)
#     set (GEOS_ENABLE_MACOSX_FRAMEWORK_UNIXCOMPAT ON)
# else()
#     set (GEOS_ENABLE_MACOSX_FRAMEWORK OFF)
# endif()


message ("Installing ${geos_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${geos_NAME}
    DEPENDS             
    PREFIX              ${BUILDEM_DIR}
    URL                 ${geos_URL}
    URL_MD5             ${geos_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${geos_SRC_DIR}/configure
        --prefix=${BUILDEM_DIR}
        "LDFLAGS=${BUILDEM_LDFLAGS} ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
        "CPPFLAGS=-I${BUILDEM_DIR}/include ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${geos_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT geos_NAME)
