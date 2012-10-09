# Define macro for caching download locally.  Useful espcially for frequent tests.
# 
# Sets the following variables:
#    ${ABBREV}_URL    The URL used for external project downloads.
#    ${ABBREV}_FILE   The base filename of the download

macro (cache_download ABBREV BASEFILE PREFIX_URL)

if (TEST_DOWNLOAD_CACHE_DIR AND EXISTS ${TEST_DOWNLOAD_CACHE_DIR}/${BASEFILE})
    set (${ABBREV}_URL ${TEST_DOWNLOAD_CACHE_DIR}/${BASEFILE})
else ()
    set (${ABBREV}_URL ${PREFIX_URL}/${BASEFILE})
endif ()

if (TEST_DOWNLOAD_CACHE_DIR)
	message ("Will cache downloads for ${${ABBREV}_NAME}.")
	add_custom_command (
	    OUTPUT ${TEST_DOWNLOAD_CACHE_DIR}/${BASEFILE}
	    DEPENDS ${FLYEM_BUILD_DIR}/src/${BASEFILE} ${${ABBREV}_NAME}
	    COMMAND ${CMAKE_COMMAND} -E make_directory ${TEST_DOWNLOAD_CACHE_DIR}
	    COMMAND ${CMAKE_COMMAND} -E copy ${FLYEM_BUILD_DIR}/src/${BASEFILE} ${TEST_DOWNLOAD_CACHE_DIR})
		COMMENT "Copied ${FLYEM_BUILD_DIR}/src/${BASEFILE} to ${TEST_DOWNLOAD_CACHE_DIR}"
endif ()

endmacro (cache_download)

