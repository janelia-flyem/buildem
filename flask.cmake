#
# Install flask library from source
#

if (NOT flask_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (jinja)
include (werkzeug)

external_source (flask
    0.9
    Flask-0.9.tar.gz
    4a89ef2b3ab0f151f781182bd0cc8933
    http://pypi.python.org/packages/source/F/Flask)

message ("Installing ${flask_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${flask_NAME}
    DEPENDS             ${python_NAME} ${jinja_NAME} ${werkzeug_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${flask_URL}
    URL_MD5             ${flask_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${flask_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT flask_NAME)
