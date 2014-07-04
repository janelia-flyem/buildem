#
# Install armadillo from source
#

if (NOT armadillo_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (blas)


external_source (armadillo
    4.000.2
    armadillo-4.000.2.tar.gz
    b2891c7b59b96337c154c5d961fd40fb
    http://downloads.sourceforge.net/project/arma
    "FORCE"
    )

message ("Installing ${armadillo_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${armadillo_NAME}
    DEPENDS             ${lapack_NAME} ${blas_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${armadillo_URL}
    URL_MD5             ${armadillo_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
    	${armadillo_SRC_DIR}/include/armadillo_bits/config.hpp
        ${PATCH_DIR}/armadillo.patch


    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${armadillo_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${armadillo_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT armadillo_NAME)
