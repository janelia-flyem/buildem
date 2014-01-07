#
# Install ilastik headless (non-GUI) from source
#
# Ilastik is composed of 3 git repos, 2 of which are necessary for headless mode.
#
# lazyflow
# ilastik
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
include (cylemon)
include (yapsy)
include (pgmlink)
include (scikit-learn)

# select the desired ilastik commit
set(DEFAULT_ILASTIK_VERSION "20131205")
IF(NOT DEFINED ILASTIK_VERSION)
    SET(ILASTIK_VERSION "${DEFAULT_ILASTIK_VERSION}")
ENDIF()
SET(ILASTIK_VERSION ${ILASTIK_VERSION}
    CACHE STRING "Specify ilastik branch/tag/commit to be used (default: ${DEFAULT_ILASTIK_VERSION})"
    FORCE)
    
external_git_repo (ilastik
    ${ILASTIK_VERSION}
    https://github.com/janelia-flyem/flyem-ilastik
    ilastik)
set(lazyflow_SRC_DIR "${ilastik_SRC_DIR}/lazyflow")

if("${ILASTIK_VERSION}" STREQUAL "master")

    set(ILASTIK_UPDATE_COMMAND git checkout master && git pull && git submodule update --init --recursive
                               cd lazyflow && git checkout master && git pull && git submodule update && cd .. &&
                               cd volumina && git checkout master && git pull && cd .. &&
                               cd ilastik && git checkout master && git pull && cd ..)

else()

    set(ILASTIK_UPDATE_COMMAND git checkout ${ILASTIK_VERSION} && git submodule update --init --recursive)
    
endif()
    
message ("Installing ${ilastik_NAME}/${ILASTIK_VERSION} into FlyEM build area: ${BUILDEM_DIR} ...")

set (ilastik_dependencies ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} ${yapsy_NAME}
                            ${cylemon_NAME} ${scikit-learn_NAME})

if (${build_pgmlink})
    # Tracking depends on pgmlink, which depends on CPLEX.
    # Most people don't have CPLEX installed on their system.
    message ("Building ilastik with CPLEX located in ${CPLEX_ROOT_DIR}")
    set (ilastik_dependencies ${ilastik_dependencies}  ${pgmlink_NAME})
endif()

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac OS X, building drtile requires explicitly setting several cmake cache variables
    ExternalProject_Add(${ilastik_NAME}
        DEPENDS             ${ilastik_dependencies}
        SOURCE_DIR          ${ilastik_SRC_DIR}
        GIT_REPOSITORY      ${ilastik_URL}
        UPDATE_COMMAND      ${ILASTIK_UPDATE_COMMAND}
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND}
            -DLIBRARY_OUTPUT_PATH=${lazyflow_SRC_DIR}/lazyflow/drtile
            -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
            -DPYTHON_EXECUTABLE=${PYTHON_EXE}
            -DPYTHON_INCLUDE_DIR=${PYTHON_PREFIX}/include/python2.7
            "-DPYTHON_LIBRARY=${PYTHON_PREFIX}/lib/libpython2.7.${BUILDEM_PLATFORM_DYLIB_EXTENSION}"
            -DPYTHON_NUMPY_INCLUDE_DIR=${PYTHON_PREFIX}/lib/python2.7/site-packages/numpy/core/include
            -DVIGRA_NUMPY_CORE_LIBRARY=${PYTHON_PREFIX}/lib/python2.7/site-packages/vigra/vigranumpycore.so
            ${lazyflow_SRC_DIR}/lazyflow/drtile
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
        TEST_COMMAND        ${BUILDEM_DIR}/bin/ilastik_headless_test
        INSTALL_COMMAND     ""
    )
else()
    # On Linux, building drtile requires less explicit configuration
    # The explicit configuration above would probably work, but let's keep this simple...
    ExternalProject_Add(${ilastik_NAME}
        DEPENDS             ${ilastik_dependencies}
        SOURCE_DIR          ${ilastik_SRC_DIR}
        GIT_REPOSITORY      ${ilastik_URL}
        UPDATE_COMMAND      ${ILASTIK_UPDATE_COMMAND}
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND}
            -DLIBRARY_OUTPUT_PATH=${lazyflow_SRC_DIR}/lazyflow/drtile
#            -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
#            -DVIGRA_ROOT=${BUILDEM_DIR}
            ${lazyflow_SRC_DIR}/lazyflow/drtile
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
        TEST_COMMAND        ${BUILDEM_DIR}/bin/ilastik_headless_test
        INSTALL_COMMAND     ""
    )
endif()

file(RELATIVE_PATH ILASTIK_DIR_RELATIVE ${BUILDEM_DIR} ${ilastik_SRC_DIR})
file(RELATIVE_PATH PYTHON_PREFIX_RELATIVE ${BUILDEM_DIR} ${PYTHON_PREFIX})

# Add environment setting script
set(SETENV_ILASTIK setenv_ilastik_gui)
configure_file(${TEMPLATE_DIR}/${SETENV_ILASTIK}.in ${BUILDEM_DIR}/bin/${SETENV_ILASTIK}.sh @ONLY)

# Add headless launch script
set(LAUNCH_ILASTIK "ilastik/ilastik.py --headless")
configure_file(${TEMPLATE_DIR}/ilastik_script.template ${BUILDEM_DIR}/bin/ilastik_headless @ONLY)

# Add headless test script
set(LAUNCH_ILASTIK ilastik/tests/test_applets/pixelClassification/testPixelClassificationHeadless.py)
configure_file(${TEMPLATE_DIR}/ilastik_script.template ${BUILDEM_DIR}/bin/ilastik_headless_test @ONLY)

# Add headless launch script for cluster processing
set(LAUNCH_ILASTIK ilastik/ilastik/workflows/pixelClassification/pixelClassificationClusterized.py)
configure_file(${TEMPLATE_DIR}/ilastik_script.template ${BUILDEM_DIR}/bin/ilastik_clusterized @ONLY)

set_target_properties(${ilastik_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ilastik_NAME)

