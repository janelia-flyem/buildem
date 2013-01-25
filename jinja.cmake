#
# Install jinja library from source
#

if (NOT jinja_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (setuptools)

external_source (jinja
    2.6 
    Jinja2-2.6.tar.gz
    1c49a8825c993bfdcf55bb36897d28a2 
    http://pypi.python.org/packages/source/J/Jinja2)

message ("Installing ${jinja_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${jinja_NAME}
    DEPENDS             ${python_NAME} ${setuptools}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${jinja_URL}
    URL_MD5             ${jinja_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${jinja_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT jinja_NAME)
