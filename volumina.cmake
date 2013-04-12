#
# Install ilastik headless (non-GUI) from source
#
# Ilastik is composed of 3 git repos, 2 of which are necessary for headless mode.
#
# lazyflow
# applet-workflows
# volumina (for gui builds)
#
# Also, you must build lazyflow/lazyflow/drtile with CMake to produce drtile.so shared library.
# This is done in the CONFIGURE_COMMAND below and the shared library is saved in the
# drtile source directory.

if (NOT volumina_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (vigra)
include (h5py)
include (psutil)
include (blist)
include (greenlet)

external_git_repo (volumina
    HEAD
    http://github.com/ilastik/volumina)


message ("Installing ${volumina_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac OS X, building drtile requires explicitly setting several cmake cache variables
    ExternalProject_Add(${volumina_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} 
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${volumina_URL}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        TEST_COMMAND        ""
        INSTALL_COMMAND     ""
    )
else()
    # On Linux, building drtile requires less explicit configuration
    # The explicit configuration above would probably work, but let's keep this simple...
    ExternalProject_Add(${volumina_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} 
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${volumina_URL}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        TEST_COMMAND        ""
        INSTALL_COMMAND     ""
    )
endif()

set_target_properties(${volumina_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT volumina_NAME)

