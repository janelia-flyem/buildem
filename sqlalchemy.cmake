#
# Install sqlalchemy library from source
#

if (NOT sqlalchemy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)

external_source (sqlalchemy
    0.8.0b2
    SQLAlchemy-0.8.0b2.tar.gz
    09537c7b425d0be433f7aceabbf23d68 
    http://pypi.python.org/packages/source/S/SQLAlchemy)

message ("Installing ${sqlalchemy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${sqlalchemy_NAME}
    DEPENDS             ${python_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${sqlalchemy_URL}
    URL_MD5             ${sqlalchemy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sqlalchemy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sqlalchemy_NAME)
