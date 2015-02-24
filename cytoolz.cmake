#
# Install cytoolz library from source
#

if (NOT cytoolz_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (cytoolz
	0.7.1
	cytoolz-0.7.1.tar.gz
	ddc3cc4a00fa0bdd3e7a837cd8d2df31
	https://pypi.python.org/packages/source/c/cytoolz
)

message ("Installing ${cytoolz_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${cytoolz_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${cytoolz_URL}
    URL_MD5             ${cytoolz_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${cytoolz_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT cytoolz_NAME)
