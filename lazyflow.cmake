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

if (NOT lazyflow_NAME)

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

external_git_repo (lazyflow
    flyem-20130221
    http://github.com/ilastik/lazyflow)


message ("Installing ${lazyflow_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # On Mac OS X, building drtile requires explicitly setting several cmake cache variables
    ExternalProject_Add(${lazyflow_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} 
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${lazyflow_URL}
        UPDATE_COMMAND      ""
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
        # For some reason, python refuses to recognize the shared library unless it ends with .so.
        # Renaming it seems to do the trick
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} make && mv ${lazyflow_SRC_DIR}/lazyflow/drtile/drtile.dylib ${lazyflow_SRC_DIR}/lazyflow/drtile/drtile.so
        TEST_COMMAND        ""
        INSTALL_COMMAND     ""
    )
else()
    # On Linux, building drtile requires less explicit configuration
    # The explicit configuration above would probably work, but let's keep this simple...
    ExternalProject_Add(${lazyflow_NAME}
        DEPENDS             ${vigra_NAME} ${h5py_NAME} ${psutil_NAME} 
                            ${blist_NAME} ${greenlet_NAME} 
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${lazyflow_URL}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND}
            -DLIBRARY_OUTPUT_PATH=${lazyflow_SRC_DIR}/lazyflow/drtile
            -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
            -DVIGRA_ROOT=${BUILDEM_DIR}
            ${lazyflow_SRC_DIR}/lazyflow/drtile
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
        TEST_COMMAND        ""
        INSTALL_COMMAND     ""
    )
endif()

set_target_properties(${lazyflow_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT lazyflow_NAME)

