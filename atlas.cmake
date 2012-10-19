#
# Install atlas from source
#

if (NOT atlas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (FortranSupport)

external_source (lapack
    3.4.2
    lapack-3.4.2.tgz
    61bf1a8a4469d4bdb7604f5897179478
    http://www.netlib.org/lapack)

message ("Downloading ${lapack_NAME} tarball into FlyEM build area: ${FLYEM_BUILD_DIR} ...")

ExternalProject_Add(${lapack_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${lapack_URL}
    URL_MD5             ${lapack_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   "" 
    BUILD_COMMAND       ""
    INSTALL_COMMAND     ""
)

external_source (atlas
    3.10.0
    atlas3.10.0.tar.bz2
    2030aa079b8d040b93de7018eae90e2b
    http://downloads.sourceforge.net/project/math-atlas/Stable/3.10.0)

if (NOT EXISTS ${FLYEM_BUILD_DIR}/lib/libtatlas.so)
    message ("Installing ${atlas_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
    ExternalProject_Add(${atlas_NAME}
        DEPENDS             ${lapack_NAME}
        PREFIX              ${FLYEM_BUILD_DIR}
        URL                 ${atlas_URL}
        URL_MD5             ${atlas_MD5}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${atlas_SRC_DIR}/configure
            -C if ${CMAKE_Fortran_COMPILER}
            -F if ${CMAKE_Fortran_FLAGS_RELEASE}
            -b 64 
            --shared 
            --prefix=${FLYEM_BUILD_DIR} 
            --with-netlib-lapack-tarfile=${lapack_FILE}
        BUILD_COMMAND       ${FLYEM_ENV_STRING} make
        TEST_COMMAND        ${FLYEM_ENV_STRING} make check
        INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
    )
endif ()

endif (NOT atlas_NAME)