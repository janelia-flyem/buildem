#
# Install toolz library from source
#

if (NOT toolz_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (toolz
	0.7.1
	toolz-0.7.1.tar.gz
	550681a2819915c5724c7e8f22ab2334
	https://pypi.python.org/packages/source/t/toolz
)

message ("Installing ${toolz_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${toolz_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${toolz_URL}
    URL_MD5             ${toolz_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${toolz_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT toolz_NAME)
