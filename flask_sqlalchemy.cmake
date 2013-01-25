#
# Install flask_sqlalchemy library from source
#

if (NOT flask_sqlalchemy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (flask)

external_source (flask_sqlalchemy
    0.16
    Flask-SQLAlchemy-0.16.tar.gz
    9de0ddfa045a47b9f7e7084cddb68cbe 
    http://pypi.python.org/packages/source/F/Flask-SQLAlchemy)

message ("Installing ${flask_sqlalchemy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${flask_sqlalchemy_NAME}
    DEPENDS             ${python_NAME} ${flask_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${flask_sqlalchemy_URL}
    URL_MD5             ${flask_sqlalchemy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${flask_sqlalchemy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT flask_sqlalchemy_NAME)
