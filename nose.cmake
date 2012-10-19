#
# Install nose library from source
#

if (NOT nose_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_source (nose
    1.2.1
    nose-1.2.1.tar.gz
    735e3f1ce8b07e70ee1b742a8a53585a
    http://pypi.python.org/packages/source/n/nose/nose-1.2.1.tar.gz)


message ("Installing ${nose_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${nose_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${nose_URL}
    URL_MD5             ${nose_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py install --prefix=${FLYEM_BUILD_DIR}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

endif (NOT nose_NAME)
