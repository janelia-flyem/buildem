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


# Make sure the main directories for FlyEM build directory are already 
# created so paths won't error out.
if (NOT EXISTS ${FLYEM_BUILD_DIR}/bin)
    file (MAKE_DIRECTORY ${FLYEM_BUILD_DIR}/bin)
endif ()

if (NOT EXISTS ${FLYEM_BUILD_DIR}/lib)
    file (MAKE_DIRECTORY ${FLYEM_BUILD_DIR}/lib)
endif ()

if (NOT EXISTS ${FLYEM_BUILD_DIR}/include)
    file (MAKE_DIRECTORY ${FLYEM_BUILD_DIR}/include)
endif ()

if (NOT EXISTS ${FLYEM_BUILD_DIR}/src)
    file (MAKE_DIRECTORY ${FLYEM_BUILD_DIR}/src)
endif ()


# Initialize environment variables string to use for commands.
set (FLYEM_BIN_PATH     ${FLYEM_BUILD_DIR}/bin:$ENV{PATH})
set (FLYEM_LIB_PATH     ${FLYEM_BUILD_DIR}/lib:$ENV{LD_LIBRARY_PATH})
set (FLYEM_ENV_STRING   env PATH=${FLYEM_BIN_PATH} LD_LIBRARY_PATH=${FLYEM_LIB_PATH})

# Set standard include directories.
include_directories (BEFORE ${FLYEM_BUILD_DIR}/include)


endif (NOT FLYEM_ENV_STRING)

