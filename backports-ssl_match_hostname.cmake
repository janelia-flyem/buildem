# Provides match_hostname from Python 3 for Python 2.
# Required by tornado.

if (NOT backports-ssl_match_hostname_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)

external_source(backports-ssl_match_hostname
    3.4.0.2
    backports.ssl_match_hostname-3.4.0.2.tar.gz
    788214f20214c64631f0859dc79f23c6
    https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/)

message ("Installing ${backports-ssl_match_hostname_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${backports-ssl_match_hostname_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${backports-ssl_match_hostname_URL}
    URL_MD5             ${backports-ssl_match_hostname_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${backports-ssl_match_hostname_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT backports-ssl_match_hostname_NAME)