#
# Install matplotlib library from source
#

if (NOT matplotlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (numpy)
include (libpng)
include (freetype2)

external_source (matplotlib
    1.1.1
    matplotlib-1.1.1.tar.gz
    8cbeaae8ba9da703d926e74c3e7c8a57
    http://downloads.sourceforge.net/project/matplotlib/matplotlib/matplotlib-1.1.1)

message ("Installing ${matplotlib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${matplotlib_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${libpng_NAME} ${freetype2_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${matplotlib_URL}
    URL_MD5             ${matplotlib_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${TEMPLATE_EXE}
        ${TEMPLATE_DIR}/matplotlib-setup-cfg.template
        ${matplotlib_SRC_DIR}/setup.cfg 
        ${BUILDEM_DIR}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

endif (NOT matplotlib_NAME)
