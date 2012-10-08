if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

# Define macro for location of each download target source code
macro (set_src_dir TARGET_ABBREV TARGET_NAME)
set (${TARGET_NAME}_SRC_DIR   "${FLYEM_BUILD_DIR}/src/${TARGET_NAME}")
set (${TARGET_ABBREV}_SRC_DIR "${FLYEM_BUILD_DIR}/src/${TARGET_NAME}")
endmacro (set_src_dir)

