# Macro support for downloading and installing components.  This reduces
# the boilerplate for each component to its minimum.
#
# A 5th optional parameter is an external download URL.  If this is provided
# and the 6th optional parameter is "FORCE", only this external download URL
# will be used and the default FlyEM cache will be ignored.
#
# The output ${ABBREV}_URL is dependent on the variable USE_PROJECT_DOWNLOAD,
# which contains a list of project abbreviations that should use original
# project download links instead of our cached FlyEM downloads.
#
# Sets the following variables:
#    DEFAULT_DOWNLOAD_SITE  URL of cache for required software tarballs

# The macro external_source(ABBREV) modifies/sets the following variables:
#    APP_DEPENDENCIES       A list of all targets included (i.e., necessary)
#    ${ABBREV}_URL          URL used for external project downloads.
#    ${ABBREV}_FILE         The full path to the downloaded compressed file
#    ${ABBREV}_FILE_MD5     The MD5 checksum of the compressed file
#    ${ABBREV}_RELEASE      The release identifier
#    ${ABBREV}_NAME         A simple identifier with just the name + version
#    ${ABBREV}_SRC_DIR      The directory containing the downloaded source code

if (NOT external_source)

if (NOT FLYEM_BUILD_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DFLYEM_BUILD_DIR=<path> on cmake command line.")
endif ()

# URL of cache for required software tarballs
set (DEFAULT_DOWNLOAD_SITE http://janelia-flyem.github.com/downloads)

# Define macro to set a number of variables per external project source
macro (external_source ABBREV SRC_VERSION FILENAME MD5)

    set (external_source_name  ${ABBREV}-${SRC_VERSION})
    # Append this external source name to our list of dependencies
    if (NOT ${ABBREV}_NAME)
        if (NOT APP_DEPENDENCIES)
            set (APP_DEPENDENCIES ${external_source_name})
        else ()
            set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${external_source_name})
        endif ()
    endif ()

    set (${ABBREV}_NAME     ${external_source_name})
    set (${ABBREV}_FILE     ${FLYEM_BUILD_DIR}/src/${FILENAME})
    set (${ABBREV}_MD5      ${MD5})
    set (${ABBREV}_RELEASE  ${SRC_VERSION})
    set (${ABBREV}_SRC_DIR  ${FLYEM_BUILD_DIR}/src/${${ABBREV}_NAME})

    if (${ARGC} GREATER 4)
        set (PREFIX_URL ${ARGV4})
    endif ()

    set (use_default TRUE)
    if (${ARGC} EQUAL 6)
        if (${ARGV5} STREQUAL "FORCE")
            set (use_default FALSE)
        else ()
            message (FATAL_ERROR "Syntax error on calling external_source(): 6th parameter can only be FORCE")
        endif ()
    endif ()

    if (USE_PROJECT_DOWNLOAD AND PREFIX_URL)
        foreach (proj ${USE_PROJECT_DOWNLOAD})
            if (proj STREQUAL ${ABBREV})
                set (use_default FALSE)
            endif ()
        endforeach (proj)
    endif (USE_PROJECT_DOWNLOAD AND PREFIX_URL)

    if (${use_default})
        set (${ABBREV}_URL  ${DEFAULT_DOWNLOAD_SITE}/${FILENAME})
    else ()
        set (${ABBREV}_URL  ${PREFIX_URL}/${FILENAME})
    endif ()
    message ("Required software ${ABBREV}-${SRC_VERSION} will be retrieved from ${${ABBREV}_URL}")

endmacro (external_source)

endif (NOT external_source)

