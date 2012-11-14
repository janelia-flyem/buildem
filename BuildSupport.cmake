# Initialize FlyEM build variables
# 
# Sets the following variables:
#    BUILDEM_BIN_PATH     Command path string suitable for PATH environment variable.
#    BUILDEM_LIB_PATH     Library path string suitable for LD_LIBRARY_PATH environment variable.
#    BUILDEM_ENV_STRING   Environment variable setting string for use before commands.

if (NOT BUILDEM_ENV_STRING)


if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()


# Make sure the main directories for FlyEM build directory are already 
# created so paths won't error out.
if (NOT EXISTS ${BUILDEM_DIR}/bin)
    file (MAKE_DIRECTORY ${BUILDEM_DIR}/bin)
endif ()

if (NOT EXISTS ${BUILDEM_DIR}/lib)
    file (MAKE_DIRECTORY ${BUILDEM_DIR}/lib)
endif ()

if (NOT EXISTS ${BUILDEM_DIR}/include)
    file (MAKE_DIRECTORY ${BUILDEM_DIR}/include)
endif ()

if (NOT EXISTS ${BUILDEM_DIR}/src)
    file (MAKE_DIRECTORY ${BUILDEM_DIR}/src)
endif ()

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Important to use FALLBACK variable.
    # https://developer.apple.com/library/mac/#documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/DynamicLibraryUsageGuidelines.html
    set (BUILDEM_LD_LIBRARY_VAR "DYLD_FALLBACK_LIBRARY_PATH")
    set (BUILDEM_PLATFORM_SPECIFIC_ENV "MACOSX_DEPLOYMENT_TARGET=10.5")
    set (BUILDEM_PLATFORM_DYLIB_EXTENSION "dylib")
else()
    set (BUILDEM_LD_LIBRARY_VAR "LD_LIBRARYPATH")
    set (BUILDEM_PLATFORM_SPECIFIC_ENV "")
    set (BUILDEM_PLATFORM_DYLIB_EXTENSION "so")
endif()

# Initialize environment variables string to use for commands.
set (BUILDEM_BIN_PATH     ${BUILDEM_DIR}/bin:$ENV{PATH})
set (BUILDEM_LIB_PATH     ${BUILDEM_DIR}/lib:$ENV{${BUILDEM_LD_LIBRARY_VAR}})
set (BUILDEM_ENV_STRING   env PATH=${BUILDEM_BIN_PATH} ${BUILDEM_LD_LIBRARY_VAR}=${BUILDEM_LIB_PATH} ${BUILDEM_PLATFORM_SPECIFIC_ENV})
set (BUILDEM_LDFLAGS      "-Wl,-rpath,${BUILDEM_DIR}/lib -L${BUILDEM_DIR}/lib")

# Set standard include directories.
include_directories (BEFORE ${BUILDEM_DIR}/include)


endif (NOT BUILDEM_ENV_STRING)

