
# select the desired blas implementation
IF(NOT DEFINED WITH_ATLAS)
    SET(WITH_ATLAS "OFF")
ENDIF()
SET(WITH_ATLAS ${WITH_ATLAS}
    CACHE BOOL "Use ATLAS (WITH_ATLAS=1) or openBLAS (WITH_ATLAS=0) ?"
    FORCE)


if(WITH_ATLAS)
    include (atlas)
    set(blas_NAME ${atlas_NAME})
else()
    include (openblas)
    set(blas_NAME ${openblas_NAME})
endif()

set (ENV{BLAS}  ${BUILDEM_DIR}/lib)
set (ENV{LAPACK} ${BUILDEM_DIR}/lib)
