# A Pure Python library for building parsers fro DSLs.

if (NOT funcparserlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (funcparserlib
    0.3.6
    funcparserlib-0.3.6.tar.gz
    3aba546bdad5d0826596910551ce37c0
    https://pypi.python.org/packages/source/f/funcparserlib/)


# Download and install funcparserlib
message ("Installing ${funcparserlib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${funcparserlib_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${funcparserlib_URL}
    URL_MD5             ${funcparserlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${funcparserlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT funcparserlib_NAME)
