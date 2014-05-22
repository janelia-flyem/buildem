#
# Install psutil library from source
#

if (NOT psutil_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (psutil
	2.1.1
	psutil-2.1.1.tar.gz
	72a6b15d589fab11f6ca245b775bc3c6
	https://pypi.python.org/packages/source/p/psutil
	FORCE
)

message ("Installing ${psutil_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${psutil_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${psutil_URL}
    URL_MD5             ${psutil_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${psutil_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT psutil_NAME)
