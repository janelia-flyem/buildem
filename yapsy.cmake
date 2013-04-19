#
# Install yapsy library from source
#

if (NOT yapsy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (yapsy
    1.10
    Yapsy-1.10-pythons2n3.tar.gz
    c2760d5d0043c30b3d9141743abb6764
    http://downloads.sourceforge.net/project/yapsy/Yapsy-1.10)

message ("Installing ${yapsy_NAME} into BuildEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${yapsy_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${yapsy_URL}
    URL_MD5             ${yapsy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${yapsy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT yapsy_NAME)
