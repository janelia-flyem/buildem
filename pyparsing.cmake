# Pyparsing is a dependency of matplotlib.
# Used to render formulae.

if (NOT pyparsing_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (pyparsing
    2.0.1
    pyparsing-2.0.1.tar.gz
    37adec94104b98591507218bc82e7c31
    https://pypi.python.org/packages/source/p/pyparsing/)


# Download and install pyparsing
message ("Installing ${pyparsing_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pyparsing_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pyparsing_URL}
    URL_MD5             ${pyparsing_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pyparsing_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyparsing_NAME)