# Macro support for downloading and installing components.  This reduces
# the boilerplate for each component to its minimum.
# 
# Sets the following variables:
#    ${ABBREV}_URL      The URL used for external project downloads.
#    ${ABBREV}_FILE     The full path to the downloaded compressed file
#    ${ABBREV}_RELEASE  The release identifier
#    ${ABBREV}_NAME     A simple identifier with just the name + version
#    ${ABBREV}_SRC_DIR  The directory containing the downloaded source code

if (NOT external_source)


if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()


# Define macro to set a number of variables per external project source
macro (external_source ABBREV SRC_VERSION FILENAME PREFIX_URL)

set (${ABBREV}_NAME     ${ABBREV}-${SRC_VERSION})
set (${ABBREV}_FILE     ${FLYEM_BUILD_DIR}/src/${FILENAME})
set (${ABBREV}_RELEASE  ${SRC_VERSION})
set (${ABBREV}_URL      ${PREFIX_URL}/${FILENAME})
set (${ABBREV}_SRC_DIR  ${FLYEM_BUILD_DIR}/src/${${ABBREV}_NAME})

endmacro (external_source)


endif (NOT external_source)

