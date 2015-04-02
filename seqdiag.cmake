# Sequence-based diagramming from a DSL.

if (NOT seqdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (pillow)
include (funcparserlib)

external_source (seqdiag
    0.9.5
    seqdiag-0.9.5.tar.gz
    18b05be0467a23b7d8569a937d6de02b
    https://pypi.python.org/packages/source/a/seqdiag/)


# Download and install seqdiag
message ("Installing ${seqdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${seqdiag_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${pillow_NAME} ${funcparserlib}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${seqdiag_URL}
    URL_MD5             ${seqdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${seqdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT seqdiag_NAME)
