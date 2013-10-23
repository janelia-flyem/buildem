#
# Install OpenBLAS from source
#

if (NOT openblas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo (openblas
    0.2.8
    https://github.com/xianyi/OpenBLAS)

message ("Installing ${openblas_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openblas_NAME}
#    DEPENDS            
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${openblas_URL}
    GIT_TAG             v0.2.8
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       make NO_AVX=1 NO_AFFINITY=1 -j8
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     make PREFIX=${BUILDEM_DIR} install &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/libblas.so &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/liblapack.so
)

set_target_properties(${openblas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openblas_NAME)
