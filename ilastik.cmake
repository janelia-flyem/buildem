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

if (NOT ilastik_NAME)

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
include (volumina)
include (lazyflow)
include (yapsy)

external_git_repo (ilastik
    HEAD
    http://github.com/ilastik/ilastik)


message ("Installing ${ilastik_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac OS X, building drtile requires explicitly setting several cmake cache variables
    ExternalProject_Add(${ilastik_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} ${volumina_NAME}
			    ${lazyflow_NAME} ${yapsy_NAME}
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
    ExternalProject_Add(${ilastik_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME}
			    ${volumina_NAME}
			    ${lazyflow_NAME} ${yapsy_NAME}
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${ilastik_URL}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ""
        BUILD_COMMAND       ""
        TEST_COMMAND        ${BUILDEM_DIR}/bin/ilastik_headless_test
        INSTALL_COMMAND     ""
    )
endif()

# Add environment setting script
ExternalProject_add_step(${ilastik_NAME}  install_env_script
    DEPENDEES   download
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/setenv_ilastik_headless.template
        ${BUILDEM_DIR}/bin/setenv_ilastik_headless.sh
        ${BUILDEM_LD_LIBRARY_VAR}
        ${BUILDEM_DIR}
        ${ilastik_SRC_DIR}
        ${PYTHON_PREFIX}
    COMMENT     "Adding ilastik headless environment script to bin directory"
)

# Add headless launch and test scripts
ExternalProject_add_step(${ilastik_NAME}  install_launch
    DEPENDEES   install_env_script
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_headless
        ${BUILDEM_DIR}/bin/setenv_ilastik_headless.sh
        ${ilastik_SRC_DIR}/workflows/pixelClassification/pixelClassificationWorkflowMainHeadless.py
    COMMENT     "Adding ilastik headless command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_test
    DEPENDEES   install_launch
    DEPENDERS   test
    COMMAND     ${BUILDEM_ENV_STRING} ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_headless_test
        ${BUILDEM_DIR}/bin/setenv_ilastik_headless.sh
        ${ilastik_SRC_DIR}/tests/test_applets/pixelClassification/testPixelClassificationHeadless.py
    COMMENT     "Adding ilastik headless test command to bin directory"
)

set_target_properties(${ilastik_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ilastik_NAME)

