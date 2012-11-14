# Set environment variable and pkgconfig directories if not already set.
#
# Sets the following variable:
#   BUILDEM_PKGCONFIG_DIR

if (NOT BUILDEM_PKGCONFIG_DIR)

if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

set (ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${BUILDEM_DIR}/lib/pkgconfig")
set (BUILDEM_PKGCONFIG_DIR "${BUILDEM_DIR}/lib/pkgconfig")

endif (NOT BUILDEM_PKGCONFIG_DIR)

