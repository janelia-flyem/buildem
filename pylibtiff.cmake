#
# Provides a thin wrapper for libtiff to be used from Python.
#

if (NOT pylibtiff_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (libtiff)
include (python)
include (setuptools)
include (numpy)
include (nose)

external_source (pylibtiff
    0.4.0
    libtiff-0.4.0.tar.gz
    f7cad14620548b21bf05a276a040f487
    http://pypi.python.org/packages/source/l/libtiff/)


# Download and install pylibtiff
message ("Installing ${pylibtiff_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pylibtiff_NAME}
    DEPENDS             ${libtiff_NAME} ${python_NAME} ${setuptools_NAME} ${numpy_NAME} ${nose_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pylibtiff_URL}
    URL_MD5             ${pylibtiff_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pylibtiff_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pylibtiff_NAME)
