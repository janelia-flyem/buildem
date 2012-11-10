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

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Important to use FALLBACK variable.
    # https://developer.apple.com/library/mac/#documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryUsageGuidelines.html
    set (FLYEM_LD_LIBRARY_VAR "DYLD_FALLBACK_LIBRARY_PATH")
    set (FLYEM_PLATFORM_SPECIFIC_ENV "MACOSX_DEPLOYMENT_TARGET=10.5")
    set (FLYEM_PLATFORM_DYLIB_EXTENSION "dylib")
else()
    set (FLYEM_LD_LIBRARY_VAR "LD_LIBRARYPATH")
    set (FLYEM_PLATFORM_SPECIFIC_ENV "")
    set (FLYEM_PLATFORM_DYLIB_EXTENSION "so")
endif()

# Initialize environment variables string to use for commands.
set (FLYEM_BIN_PATH     ${FLYEM_BUILD_DIR}/bin:$ENV{PATH})
set (FLYEM_LIB_PATH     ${FLYEM_BUILD_DIR}/lib:$ENV{${FLYEM_LD_LIBRARY_VAR}})
set (FLYEM_ENV_STRING   env PATH=${FLYEM_BIN_PATH} ${FLYEM_LD_LIBRARY_VAR}=${FLYEM_LIB_PATH} ${FLYEM_PLATFORM_SPECIFIC_ENV})
set (FLYEM_LDFLAGS      "-Wl,-rpath,${FLYEM_BUILD_DIR}/lib -L${FLYEM_BUILD_DIR}/lib")

# Set standard include directories.
include_directories (BEFORE ${FLYEM_BUILD_DIR}/include)


endif (NOT FLYEM_ENV_STRING)

