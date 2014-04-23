#
# Install OpenBLAS from source
#

if (NOT openblas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo (openblas
    4d42368214f2fd102b2d163c086e0f2d8c166dc6
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
    # Add TARGET=xxx (where xxx is an architecture) to the BUILD_COMMAND to optimize and/or avoid particular build errors. See README_openblas.txt for details.
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE) NO_AVX=1 NO_AFFINITY=1 -j8
    BUILD_IN_SOURCE     1
    # Add TARGET=xxx (where xxx is an architecture) to the BUILD_COMMAND to optimize and/or avoid particular build errors. See README_openblas.txt for details.
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) PREFIX=${BUILDEM_DIR} install &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/libblas.so &&
                        ln -fs libopenblas.so ${BUILDEM_DIR}/lib/liblapack.so
)

set_target_properties(${openblas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openblas_NAME)
