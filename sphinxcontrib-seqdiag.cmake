# Sphinx embedding of seqdiag.

if (NOT sphinxcontrib-seqdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (sphinx)
include (seqdiag)

external_source (sphinxcontrib-seqdiag
    0.8.1
    sphinxcontrib-seqdiag-0.8.1.tar.gz
    ef9ad01798b5cf46247ab1fbe4ff781c
    https://pypi.python.org/packages/source/s/sphinxcontrib-seqdiag/)


# Download and install sphinxcontrib-seqdiag
message ("Installing ${sphinxcontrib-seqdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinxcontrib-seqdiag_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME} ${seqdiag_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinxcontrib-seqdiag_URL}
    URL_MD5             ${sphinxcontrib-seqdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinxcontrib-seqdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinxcontrib-seqdiag_NAME)
