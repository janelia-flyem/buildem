#
# Install matplotlib library from source.
# Includes dependencies to try to avoid use of easy_install, which matplotlib will try.
#
# However, we will let matplotlib install its own copy of PyCXX and LibAgg, which it comes prepackaged with.
# This will help avoid incompatibilities. Also, some version PyCXX are not compatible with some versions of Python.
#

if (NOT matplotlib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (pyqt4)
include (six)
include (setuptools)
include (pytz)
include (python-dateutil)
include (pyparsing)
include (numpy)
include (libpng)
include (ffmpeg)
include (freetype2)
include (nose)
include (mock)
include (tornado)

external_git_repo(matplotlib
        v1.4.2 # 3a828ddb7df3bc597254f875cbbac6aadf48aee0
        https://github.com/matplotlib/matplotlib)

message ("Installing ${matplotlib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${matplotlib_NAME}
    DEPENDS             ${python_NAME} ${pyqt4} ${six_NAME} ${setuptools_NAME} ${pytz_NAME} ${python-dateutil_NAME} ${pyparsing_NAME} ${numpy_NAME} ${libpng_NAME} ${ffmpeg_NAME} ${freetype2_NAME} ${nose_NAME} ${mock_NAME} ${tornado_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${matplotlib_URL}
    GIT_TAG             ${matplotlib_TAG}
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

set_target_properties(${matplotlib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT matplotlib_NAME)
