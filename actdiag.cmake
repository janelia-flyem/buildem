# Action-based diagramming from a DSL.

if (NOT actdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (pillow)
include (funcparserlib)

external_source (actdiag
    0.5.4
    actdiag-0.5.4.tar.gz
    d254a4dbac727ba7bee1b252e530cb3f
    https://pypi.python.org/packages/source/a/actdiag/)


# Download and install actdiag
message ("Installing ${actdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${actdiag_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${pillow_NAME} ${funcparserlib}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${actdiag_URL}
    URL_MD5             ${actdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${actdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT actdiag_NAME)
