#
# Install mlpack from source
#

if (NOT mlpack_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (armadillo)
include (boost)
include (libxml2)


external_source (mlpack
    1.0.8
    mlpack-1.0.8.tar.gz
    0331e12f2485b9d5d39c9d9dea618108
    http://www.mlpack.org/files
    "FORCE")

message ("Installing ${mlpack_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${mlpack_NAME}
    DEPENDS             ${armadillo_NAME} ${boost_NAME} ${libxml2_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${mlpack_URL}
    URL_MD5             ${mlpack_MD5}
    UPDATE_COMMAND      ""


    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${mlpack_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
	-DCMAKE_CXX_FLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DLIBXML2_INCLUDE_DIR=${BUILDEM_DIR}/include/libxml2


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    # TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
)

set_target_properties(${mlpack_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mlpack_NAME)
