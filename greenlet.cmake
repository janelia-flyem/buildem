#
# Install greenlet library from source
#

if (NOT greenlet_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (greenlet
    0.4.0
    greenlet-0.4.0.zip
    87887570082caadc08fb1f8671dbed71
    http://pypi.python.org/packages/source/g/greenlet)

message ("Installing ${greenlet_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${greenlet_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${greenlet_URL}
    URL_MD5             ${greenlet_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${greenlet_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT greenlet_NAME)
