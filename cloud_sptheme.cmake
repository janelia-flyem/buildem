#
# Install cloud_sptheme from source. Provides theme for Sphinx.
#

if (NOT cloud_sptheme_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (sphinx)

external_source (cloud_sptheme
    1.6
    cloud_sptheme-1.6.tar.gz
    23d5fce0b87836d9f29573d6ee6a9bc1
    https://pypi.python.org/packages/source/c/cloud_sptheme/)

message ("Installing ${cloud_sptheme_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cloud_sptheme_NAME}
    DEPENDS             ${python_NAME} ${sphinx_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${cloud_sptheme_URL}
    URL_MD5             ${cloud_sptheme_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${cloud_sptheme_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cloud_sptheme_NAME)
