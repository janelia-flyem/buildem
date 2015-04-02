# Sphinx embedding of nwdiag.

if (NOT sphinxcontrib-nwdiag_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (sphinx)
include (nwdiag)

external_source (sphinxcontrib-nwdiag
    0.9.1
    sphinxcontrib-nwdiag-0.9.1.tar.gz
    f144fbd4965109930d8708be6cfc59ba
    https://pypi.python.org/packages/source/s/sphinxcontrib-nwdiag/)


# Download and install sphinxcontrib-nwdiag
message ("Installing ${sphinxcontrib-nwdiag_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinxcontrib-nwdiag_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME} ${nwdiag_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinxcontrib-nwdiag_URL}
    URL_MD5             ${sphinxcontrib-nwdiag_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinxcontrib-nwdiag_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinxcontrib-nwdiag_NAME)
