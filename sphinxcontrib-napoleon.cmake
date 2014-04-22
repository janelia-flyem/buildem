# Extends Sphinx to add support for Google style and Numpy style documentation.
# Much easier on the eyes and brain than Sphinx.

if (NOT sphinxcontrib-napoleon_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (sphinx)

external_source (sphinxcontrib-napoleon
    0.2.7
    sphinxcontrib-napoleon-0.2.7.tar.gz
    001ee10b53eba1361738ed126cd6deb2
    https://pypi.python.org/packages/source/s/sphinxcontrib-napoleon/)


# Download and install sphinxcontrib-napoleon
message ("Installing ${sphinxcontrib-napoleon_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${sphinxcontrib-napoleon_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sphinxcontrib-napoleon_URL}
    URL_MD5             ${sphinxcontrib-napoleon_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sphinxcontrib-napoleon_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sphinxcontrib-napoleon_NAME)