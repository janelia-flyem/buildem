#
# Provides Python bindings to GEOS as well as additional functionality in analyzing and manipulating geometric objects.
#

if (NOT shapely_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)
include (cython)
include (numpy)
include (geos)

external_git_repo(shapely
        1.4.3 # 53424e60ba8b83bbdce84a8e238b201b83c53a7d
        https://github.com/Toblerity/Shapely)


# Download and install shapely
message ("Installing ${shapely_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${shapely_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME} ${cython_NAME} ${numpy_NAME} ${geos_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${shapely_URL}
    GIT_TAG             ${shapely_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${shapely_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT shapely_NAME)
