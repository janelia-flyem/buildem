#
# Install python-geojson library from source.
#

if (NOT python-geojson_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)

external_git_repo(python-geojson
        1.0.9 # 0c68ce74d4472f957b31c336bfd41b719d8dfa00
        https://github.com/frewsxcv/python-geojson)

message ("Installing ${python-geojson_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${python-geojson_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${python-geojson_URL}
    GIT_TAG             ${python-geojson_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${python-geojson_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python-geojson_NAME)
