#
# Install progressbar library from source
#

if (NOT progressbar_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (progressbar
    2.3
    progressbar-2.3.tar.gz
    4f904e94b783b4c6e71aa74fd2432c59
    http://python-progressbar.googlecode.com/files/)

message ("Installing ${progressbar_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${progressbar_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${progressbar_URL}
    URL_MD5             ${progressbar_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

endif (NOT progressbar_NAME)
