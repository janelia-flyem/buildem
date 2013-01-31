#
# Install mysql_python library from source
#

if (NOT mysql_python_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)

external_source (mysql_python
    1.2.4
    MySQL-python-1.2.4.tgz 
    95cb97765b4bbf744ab6e23df01e26f2)

message ("Installing ${mysql_python_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${mysql_python_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${mysql_python_URL}
    URL_MD5             ${mysql_python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${mysql_python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT mysql_python_NAME)
