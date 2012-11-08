#
# Install cython from source
#

if (NOT cython_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (cython
    0.17.1
    Cython-0.17.1.tar.gz
    f0bd2494dbe080a1185b61fa358135f2
    http://cython.org/release)

message ("Installing ${cython_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${cython_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${cython_URL}
    URL_MD5             ${cython_MD5}
    UPDATE_COMMAND      ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

endif (NOT cython_NAME)
