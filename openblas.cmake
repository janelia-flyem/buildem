#
# Install OpenBLAS from source
#

if (NOT openblas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo (openblas
    #v0.2.8
    HEAD
    https://github.com/xianyi/OpenBLAS)

message ("Installing ${openblas_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openblas_NAME}
#    DEPENDS            
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${openblas_URL}
    GIT_TAG             ${openblas_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    # Added Sandybridge target. This is required for SandyBridge architecture. It also will optimize for Haswell architechture, which includes Clearwell.
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) NO_AVX=1 NO_AFFINITY=1 TARGET=SANDYBRIDGE -j8
    BUILD_IN_SOURCE     1
    # Added Sandybridge target. This is required for SandyBridge architecture. It also will optimize for Haswell architechture, which includes Clearwell.
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) PREFIX=${BUILDEM_DIR} TARGET=SANDYBRIDGE install &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/libblas.so &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/liblapack.so
)

set_target_properties(${openblas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openblas_NAME)
