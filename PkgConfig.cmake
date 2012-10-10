# Set environment variable and pkgconfig directories if not already set.
#
# Sets the following variable:
#   FLYEM_PKGCONFIG_DIR

if (NOT FLYEM_PKGCONFIG_DIR)

if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

set (ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${FLYEM_BUILD_DIR}/lib/pkgconfig")
set (FLYEM_PKGCONFIG_DIR "${FLYEM_BUILD_DIR}/lib/pkgconfig")

endif (NOT FLYEM_PKGCONFIG_DIR)

