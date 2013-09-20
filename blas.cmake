
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
    # On Mac, warn that openblas might not work.
    if (${APPLE})
        # Only emit this warning once.
        if ("${emitted_warning_for_openblas_osx}" STREQUAL "")
            message(WARNING "\n*** OpenBLAS does not always successfully build on Mac OS X.  Consider using -DWITH_ATLAS=1 instead. ***\n")
            set (emitted_warning_for_openblas_osx 1)
        endif ()
    endif ()

    include (openblas)
    set(blas_NAME ${openblas_NAME})
endif()

set (ENV{BLAS}  ${BUILDEM_DIR}/lib)
set (ENV{LAPACK} ${BUILDEM_DIR}/lib)
