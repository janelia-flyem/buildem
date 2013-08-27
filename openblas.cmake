#
# Install OpenBLAS from source
#

if (NOT openblas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)

external_git_repo (openblas
    0.2.5
    http://github.com/xianyi/OpenBLAS)
    
# NOTE: 'make' downloads and compiles lapack-3.4.2 on the fly and puts blas and lapack
#       together into libopenblas.dll. numpy wants two separate libraries, so we copy the
#       link library libopenblas.lib under the two names blas.lib and lapack.lib.

message ("Installing ${openblas_NAME} into ilastik build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${openblas_NAME}
#    DEPENDS            
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${openblas_URL}
    GIT_TAG             v0.2.5
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       make -j8 NO_AUX=1
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     make PREFIX=${BUILDEM_DIR} install
)

set_target_properties(${openblas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT openblas_NAME)
