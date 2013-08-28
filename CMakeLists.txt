CMAKE_MINIMUM_REQUIRED(VERSION 2.8.6)
project (Ilastik)

include (ExternalProject)
#include (TemplateSupport)

############################################################################
# Check if BUILDEM_DIR has already been assigned.  If not, create a default.
set (BUILDEM_DIR "None" CACHE TYPE STRING)

if (${BUILDEM_DIR} STREQUAL "None")
    message (FATAL_ERROR "ERROR: FlyEM build directory (for all downloads & builds) should be specified via -DBUILDEM_DIR=<path> on cmake command line.")
endif ()

message ("FlyEM downloads and builds will be placed here: ${BUILDEM_DIR}")

############################################################################

############################################################################
# Download and install buildem, if it isn't already in BUILDEM_DIR.
set (BUILDEM_REPO_DIR ${BUILDEM_DIR}/src/buildem)
if (NOT EXISTS ${BUILDEM_REPO_DIR}/python.cmake)
    message ("Installing buildem repo...")
    ExternalProject_Add(buildem
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      https://github.com/ilastik/buildem.git
        #GIT_TAG            python3  # Example of tagged branch (see doc)
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   "" 
        BUILD_COMMAND       ""
        BUILD_IN_SOURCE     1
        INSTALL_COMMAND     ""
    )
    message ("\n**********************************************************\n")
    message ("\nAfter running make, you must re-run the cmake command once")
    message ("buildem has been downloaded!\n")
    message ("\n***********************************************************\n")
else ()
    ############################################################################

    # Use modules from the downloaded buildem
    set (CMAKE_MODULE_PATH ${BUILDEM_REPO_DIR})
    message("Using cmake modules from ${BUILDEM_REPO_DIR}")

    # Download, compile, test, and install dependencies
    # Note the auto-generated APP_DEPENDENCIES variable holds all included targets.
    
    include (ilastik-gui)

    add_custom_target (AppDependencies ALL
        DEPENDS ${APP_DEPENDENCIES}
        COMMENT "Installed all required software using buildem.")

    # Install Foo -- actual build commands should go below

    configure_file(${TEMPLATE_DIR}/ilastik_final.in ${BUILDEM_DIR}/ilastik_final)

    #INSTALL(FILES ${BUILDEM_DIR}/ilastik_final DESTINATION bin)
    INSTALL(PROGRAMS ${BUILDEM_DIR}/ilastik_final DESTINATION . )
    #INSTALL(DIRECTORY ${BUILDEM_DIR}/bin DESTINATION . USE_SOURCE_PERMISSIONS)
    INSTALL(PROGRAMS ${BUILDEM_DIR}/bin/python2.7 DESTINATION bin/)
    INSTALL(DIRECTORY ${BUILDEM_DIR}/lib DESTINATION .)
    INSTALL(DIRECTORY ${BUILDEM_DIR}/include DESTINATION .)
    INSTALL(DIRECTORY ${BUILDEM_DIR}/src/volumina-HEAD DESTINATION src/)
    INSTALL(DIRECTORY ${BUILDEM_DIR}/src/lazyflow-HEAD DESTINATION src/)
    INSTALL(DIRECTORY ${BUILDEM_DIR}/src/ilastik-HEAD DESTINATION src/)

    SET(CPACK_GENERATOR "TGZ")

    SET(CPACK_PACKAGE_VENDOR "Heidelberg Collaboratory for Image Processing")
    SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY
      "Interactive image labeling and segmentation toolkit."
      )
    
    SET(CPACK_PACKAGE_VERSION_MAJOR "0")
    SET(CPACK_PACKAGE_VERSION_MINOR "6")
    SET(CPACK_PACKAGE_VERSION_PATCH "a")
    
    #SET(CPACK_PACKAGE_INSTALL_DIRECTORY     "${PROJECT_NAME}-0.6.a")

    SET(CPACK_STRIP_FILES TRUE)
    #SET(CPACK_PACKAGE_CONTACT "ilastik Team <team@ilastik.org>")
    
    INCLUDE (CPack)
    
############################################################################
endif()
