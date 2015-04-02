# Network-based diagramming from a DSL.

if (NOT nwdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (pillow)
include (funcparserlib)

external_source (nwdiag
    1.0.4
    nwdiag-1.0.4.tar.gz
    0d2ff1348aeff53aaf08838d0fa2c001
    https://pypi.python.org/packages/source/n/nwdiag/)


# Download and install nwdiag
message ("Installing ${nwdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${nwdiag_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${pillow_NAME} ${funcparserlib}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${nwdiag_URL}
    URL_MD5             ${nwdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${nwdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT nwdiag_NAME)
