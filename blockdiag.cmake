# Block-based diagramming from a DSL.

if (NOT blockdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (pillow)
include (funcparserlib)

external_source (blockdiag
    1.5.1
    blockdiag-1.5.1.tar.gz
    e1bcaf5ae64467f7722ad7883fc06abb
    https://pypi.python.org/packages/source/b/blockdiag/)


# Download and install blockdiag
message ("Installing ${blockdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${blockdiag_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${pillow_NAME} ${funcparserlib}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${blockdiag_URL}
    URL_MD5             ${blockdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${blockdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT blockdiag_NAME)
