# Provides functions to deal with nan in NumPy arrays efficiently.
#
# Required by pandas.


if (NOT bottleneck_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (numpy)
include (scipy)
include (nose)

external_git_repo(bottleneck
	v0.7.0 #4042977fa716f127a2074de011b9ef84caf2e965
	https://github.com/kwgoodman/bottleneck)

message ("Installing ${bottleneck_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${bottleneck_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${scipy_NAME} ${nose_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${bottleneck_URL}
    GIT_TAG             ${bottleneck_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${bottleneck_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT bottleneck_NAME)
