# Define macro for caching download locally.  Useful espcially for frequent tests.
# 
# Sets the following variables:
#    ${ABBREV}_URL    The URL used for external project downloads.
#    ${ABBREV}_FILE   The base filename of the download

if (NOT cache_init)

macro (cache_init ABBREV BASEFILE PREFIX_URL)

set (${ABBREV}_FILE ${BASEFILE})
if (TEST_DOWNLOAD_CACHE_DIR AND EXISTS ${TEST_DOWNLOAD_CACHE_DIR}/${BASEFILE})
    set (${ABBREV}_URL ${TEST_DOWNLOAD_CACHE_DIR}/${BASEFILE})
else ()
    set (${ABBREV}_URL ${PREFIX_URL}/${BASEFILE})
endif ()

endmacro (cache_init)



macro (cache_download ABBREV)

set (BASEFILE ${${ABBREV}_FILE})
if (TEST_DOWNLOAD_CACHE_DIR)
    message ("Will cache downloads for ${${ABBREV}_NAME}: ${BASEFILE}")
    ExternalProject_Add_Step (${${ABBREV}_NAME} cache
        DEPENDEES download
        COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_DOWNLOAD_CACHE_DIR}
        COMMAND ${CMAKE_COMMAND} -E copy ${FLYEM_BUILD_DIR}/src/${BASEFILE} ${TEST_DOWNLOAD_CACHE_DIR}
        COMMENT "Copied ${FLYEM_BUILD_DIR}/src/${BASEFILE} to ${TEST_DOWNLOAD_CACHE_DIR}")
endif ()

endmacro (cache_download)

endif (NOT cache_init)

