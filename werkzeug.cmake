#
# Install werkzeug library from source
#

if (NOT werkzeug_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)

external_source (werkzeug
    0.8.3 
    Werkzeug-0.8.3.tar.gz
    12aa03e302ce49da98703938f257347a 
    http://pypi.python.org/packages/source/W/Werkzeug)

message ("Installing ${werkzeug_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${werkzeug_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${werkzeug_URL}
    URL_MD5             ${werkzeug_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${werkzeug_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT werkzeug_NAME)
