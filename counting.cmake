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

if (NOT counting_NAME)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (ilastik)

set (counting_NAME ${ilastik_NAME}-counting)
message ("Installing ${counting_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac OS X, building drtile requires explicitly setting several cmake cache variables
    ExternalProject_Add(${ilastik_NAME}
	DEPENDS             

	PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${ilastik_URL}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        TEST_COMMAND        ${BUILDEM_DIR}/bin/ilastik_headless_test
        INSTALL_COMMAND     ""
    )
else()
    # On Linux, building drtile requires less explicit configuration
    # The explicit configuration above would probably work, but let's keep this simple...
    ExternalProject_Add(${counting_NAME}
        PREFIX              ${BUILDEM_DIR}
	SOURCE_DIR          ${ilastik_SRC_DIR}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
	CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} 
        -DCMAKE_INSTALL_PREFIX=${ilastik_SRC_DIR}/ilastik/applets/counting/cwrapper
        ${ilastik_SRC_DIR}/ilastik/applets/counting/cwrapper
	BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
        TEST_COMMAND        ""
        INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    )
endif()

endif (NOT counting_NAME)
