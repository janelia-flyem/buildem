# Sphinx embedding of blockdiag.

if (NOT sphinxcontrib-blockdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (sphinx)
include (blockdiag)

external_source (sphinxcontrib-blockdiag
    1.5.1
    sphinxcontrib-blockdiag-1.5.1.tar.gz
    1a031f379869875ce882be968bed6ef8
    https://pypi.python.org/packages/source/s/sphinxcontrib-blockdiag/)


# Download and install sphinxcontrib-blockdiag
message ("Installing ${sphinxcontrib-blockdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinxcontrib-blockdiag_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME} ${blockdiag_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinxcontrib-blockdiag_URL}
    URL_MD5             ${sphinxcontrib-blockdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinxcontrib-blockdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinxcontrib-blockdiag_NAME)
