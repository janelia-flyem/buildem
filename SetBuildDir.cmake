#
# Determine a build directory to store all relevant downloads and builds for a
# given OS/architecure.  The build directory can be fixed by setting BUILD_DIR
# prior to including this module.
#
# This module defines:
# FLYEM_BUILD_DIR -- the OS/architecture-specific directory for all FlyEM downloads & builds.

# Check if FLYEM_BUILD_DIR has already been assigned.  If not, create a default.
set (FLYEM_BUILD_DIR "None" CACHE TYPE STRING)

if (${FLYEM_BUILD_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path>")
endif ()
message ("FlyEM downloads and builds will be placed here: ${FLYEM_BUILD_DIR}")

# Define macro for location of each download target source code
macro (set_src_dir TARGET_ABBREV TARGET_NAME)
set (${TARGET_NAME}_SRC_DIR   "${FLYEM_BUILD_DIR}/src/${TARGET_NAME}")
set (${TARGET_ABBREV}_SRC_DIR "${FLYEM_BUILD_DIR}/src/${TARGET_NAME}")
endmacro (set_src_dir)



