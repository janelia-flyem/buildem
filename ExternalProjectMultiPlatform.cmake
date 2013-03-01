include(ExternalProject)

FUNCTION(ExternalProject_AddMultiPlatform name)
    SET(keywords 
          #--General--------------
             DEPENDS PREFIX LIST_SEPARATOR TMP_DIR STAMP_DIR 
          #--Download step--------------
             DOWNLOAD_DIR DOWNLOAD_COMMAND
             CVS_REPOSITORY CVS_MODULE CVS_TAG
             SVN_REPOSITORY SVN_REVISION SVN_USERNAME SVN_PASSWORD SVN_TRUST_CERT
             GIT_REPOSITORY GIT_TAG 
             URL URL_MD5 TIMEOUT
          #--Update/Patch step----------
             UPDATE_COMMAND PATCH_COMMAND
          #--Configure step-------------
             SOURCE_DIR CONFIGURE_COMMAND CMAKE_COMMAND CMAKE_GENERATOR CMAKE_ARGS CMAKE_CACHE_ARGS
          #--Build step-----------------
             BINARY_DIR BUILD_COMMAND BUILD_IN_SOURCE
          #--Install step--------------- 
             INSTALL_DIR INSTALL_COMMAND
          #--Test step------------------
             TEST_BEFORE_INSTALL TEST_AFTER_INSTALL TEST_COMMAND
          #--Output logging-------------
             LOG_DOWNLOAD LOG_UPDATE LOG_CONFIGURE LOG_BUILD LOG_TEST LOG_INSTALL
          #--Custom targets-------------
             STEP_TARGETS
        )

    # build the regular expression to identify keywords and 
    # initialize all keywords to "NOT_SPECIFIED"
    SET(keywords_re)
    foreach(i ${keywords})
        SET(${i} "NOT_SPECIFIED")
        if(NOT keywords_re)
            SET(keywords_re "^(PLATFORM|UNSUPPORTED|${i}")
        else()
            SET(keywords_re "${keywords_re}|${i}")
        endif()
    endforeach(i)
    SET(keywords_re "${keywords_re})$")

    # parse the arguments
    SET(command)
    SET(ignore NO)
    SET(unsupported NO)
    string(TOLOWER ${PLATFORM_SPEC} platform_lower)
    foreach(i ${ARGN})
        string(REGEX MATCH ${keywords_re} keyword ${i})
        if(keyword)
            set(command ${keyword})
            if("${command}" STREQUAL "PLATFORM")
                SET(ignore NO)
            elseif(NOT ${ignore})
                set(${command})
                if("${command}" STREQUAL "UNSUPPORTED")
                    SET(ignore YES)
                    SET(unsupported YES)
                else()
                    SET(unsupported NO)
                endif()
            endif()
        else()
            if("${command}" STREQUAL "PLATFORM")
                string(TOLOWER ${i} i_lower)
                string(REGEX MATCH ${i_lower} platform_matches "${platform_lower}")
                if("${platform_matches}" STREQUAL "")
                    SET(ignore YES)
                endif()
            elseif(NOT ${ignore})
                if(${command})
                    set(${command} "${${command}} ${i}")
                else()
                    set(${command} "${i}")
                endif()
            endif()
        endif()
    endforeach(i)

    if(DRY_RUN)
        # report results 
        if(unsupported)
            MESSAGE("platform is unsupported!")
        else()
            MESSAGE("calling ExternalProject_Add() with")
            MESSAGE("  name: ${name}")
            foreach(i ${keywords})
                if(NOT ${i} STREQUAL "NOT_SPECIFIED")
                    if("${${i}}" STREQUAL "")
                        MESSAGE("  ${i}: \"\"")
                    else()
                        MESSAGE("  ${i}: ${${i}}")
                    endif()
                endif()
            endforeach(i)
        endif()
    else()    
        if(unsupported)
            MESSAGE(FATAL_ERROR "Package ${name} doesn't support platform ${PLATFORM_SPEC}!")
        else()
            SET(project_params ${name})
            foreach(i ${keywords})
                if(NOT ${i} STREQUAL "NOT_SPECIFIED")
                    if("${${i}}" STREQUAL "")
                        SET(project_params ${project_params} ${i})
                    else()
                        string(REGEX REPLACE " +" ";" args ${${i}})
                        SET(project_params ${project_params} ${i} ${args})
                    endif()
                endif()
            endforeach(i)
            ExternalProject_Add(${project_params})
        endif()
    endif()
ENDFUNCTION(ExternalProject_AddMultiPlatform)
