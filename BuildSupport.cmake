# Initialize FlyEM build variables
# 
# Sets the following variables:
#    FLYEM_BIN_PATH     Command path string suitable for PATH environment variable.
#    FLYEM_LIB_PATH     Library path string suitable for LD_LIBRARY_PATH environment variable.
#    FLYEM_ENV_STRING   Environment variable setting string for use before commands.

if (NOT FLYEM_ENV_STRING)

if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

# Initialize environment variables string to use for commands.
set (FLYEM_BIN_PATH     ${FLYEM_BUILD_DIR}/bin:$ENV{PATH})
set (FLYEM_LIB_PATH     ${FLYEM_BUILD_DIR}/lib:$ENV{LD_LIBRARY_PATH})
set (FLYEM_ENV_STRING   "PATH=${FLYEM_BIN_PATH}  LD_LIBRARY_PATH=${FLYEM_LIB_PATH} ")

endif (NOT FLYEM_ENV_STRING)

