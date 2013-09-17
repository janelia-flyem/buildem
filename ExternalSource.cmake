# Macro support for downloading and installing components.  This reduces
# the boilerplate for each component to its minimum.
#
# A 5th optional parameter is an external download URL.  If this is provided
# and the 6th optional parameter is "FORCE", only this external download URL
# will be used and the default FlyEM cache will be ignored.
#
# Uses the following CMake variables:
#
#    USE_PROJECT_DOWNLOAD   A list of project abbreviations that should use
#                               original project links instead of our cached
#                               FlyEM downloads.
#
# Sets the following variable if not already set:
#    DEFAULT_CACHE_URL      URL of cache for required software tarballs

# The macro external_source(ABBREV) modifies/sets the following variables:
#    APP_DEPENDENCIES       A list of all targets included (i.e., necessary)
#    ${ABBREV}_URL          URL used for external project downloads.
#    ${ABBREV}_FILE         The full path to the downloaded compressed file
#    ${ABBREV}_FILE_MD5     The MD5 checksum of the compressed file
#    ${ABBREV}_RELEASE      The release identifier
#    ${ABBREV}_NAME         A simple identifier with just the name + version
#    ${ABBREV}_SRC_DIR      The directory containing the downloaded source code
#    ${ABBREV}_BUILD        "RELEASE" is set if this variable isn't set
#    ${ABBREV}_INCLUDE_DIRS 

# The macro external_git_repo(ABBREV) modifies/sets the following variables:
#    APP_DEPENDENCIES       A list of all targets included (i.e., necessary)
#    ${ABBREV}_URL          URL used for external project repo.
#    ${ABBREV}_NAME         A simple identifier with just the name + version
#    ${ABBREV}_SRC_DIR      The directory containing the working directory
#    ${ABBREV}_BUILD        "RELEASE" is set if this variable isn't set
#    ${ABBREV}_INCLUDE_DIRS 


if (NOT external_source)

if (NOT BUILDEM_DIR)
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

# URL of cache for required software tarballs
set (DEFAULT_CACHE_URL "http://janelia-flyem.github.io/downloads" CACHE TYPE STRING)

# Define macro to set a number of variables per external project source
macro (external_source ABBREV SRC_VERSION FILENAME MD5)

    # RELEASE builds are by default
    if (NOT ${ABBREV}_BUILD)
        set (${ABBREV}_BUILD "RELEASE")
    endif ()

    set (external_source_name  ${ABBREV}-${SRC_VERSION})
    # Append this external source name to our list of dependencies
    if (NOT ${ABBREV}_NAME)
        if (NOT APP_DEPENDENCIES)
            set (APP_DEPENDENCIES ${external_source_name})
        else ()
            set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${external_source_name})
        endif ()
    endif ()

    set (${ABBREV}_NAME         ${external_source_name})
    set (${ABBREV}_FILE         ${BUILDEM_DIR}/src/${FILENAME})
    set (${ABBREV}_MD5          ${MD5})
    set (${ABBREV}_RELEASE      ${SRC_VERSION})
    set (${ABBREV}_SRC_DIR      ${BUILDEM_DIR}/src/${external_source_name})
    set (${ABBREV}_INCLUDE_DIRS ${BUILDEM_DIR}/include)

    set (use_default TRUE)
    if (${ARGC} GREATER 4)
        set (PREFIX_URL ${ARGV4})
    endif ()

    if (${ARGC} GREATER 5)
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
        set (${ABBREV}_URL  ${DEFAULT_CACHE_URL}/${FILENAME})
    else ()
        set (${ABBREV}_URL  ${PREFIX_URL}/${FILENAME})
    endif ()
    message ("Required software ${ABBREV}-${SRC_VERSION} will be retrieved from ${${ABBREV}_URL}")

endmacro (external_source)

# Define macro to set a number of variables per external git repo
# Note: Besides these named args, this macro accepts the following optional args:
#  OVERRIDE_NAME - Used to override the <package>_NAME and <package>_SRC_DIR variables set by this macro
macro (external_git_repo ABBREV SRC_VERSION URL)
	# Check for extra (optional) macro args.
	set (extra_macro_args ${ARGN})
	list(LENGTH extra_macro_args num_extra_args)

    # RELEASE builds are by default
    if (NOT ${ABBREV}_BUILD)
        set (${ABBREV}_BUILD "RELEASE")
    endif ()

	# By default, package NAME and SRC_DIR are <package>-git
    set (external_source_name  ${ABBREV}-git)
    
    # First optional macro arg overrides package NAME and SRC_DIR
    if (${num_extra_args} GREATER 0)
    	list(GET extra_macro_args 0 external_source_name)
    endif ()

    message ("Setting external_git_repo: ${external_source_name}")

    # Append this external source name to our list of dependencies
    if (NOT ${ABBREV}_NAME)
        if (NOT APP_DEPENDENCIES)
            set (APP_DEPENDENCIES ${external_source_name})
        else ()
            set (APP_DEPENDENCIES ${APP_DEPENDENCIES} ${external_source_name})
        endif ()
    endif ()

    set (${ABBREV}_NAME         ${external_source_name})
    set (${ABBREV}_SRC_DIR      ${BUILDEM_DIR}/src/${external_source_name})
    set (${ABBREV}_URL          ${URL})
    set (${ABBREV}_TAG          ${SRC_VERSION})
    set (${ABBREV}_INCLUDE_DIRS ${BUILDEM_DIR}/include)

endmacro (external_git_repo)


endif (NOT external_source)

