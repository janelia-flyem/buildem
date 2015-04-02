# Sphinx embedding of actdiag.

if (NOT sphinxcontrib-actdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (sphinx)
include (actdiag)

external_source (sphinxcontrib-actdiag
    0.8.1
    sphinxcontrib-actdiag-0.8.1.tar.gz
    651e6ca4e066f38cff80746fb727a105
    https://pypi.python.org/packages/source/s/sphinxcontrib-actdiag/)


# Download and install sphinxcontrib-actdiag
message ("Installing ${sphinxcontrib-actdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinxcontrib-actdiag_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinxcontrib-actdiag_URL}
    URL_MD5             ${sphinxcontrib-actdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinxcontrib-actdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinxcontrib-actdiag_NAME)
