# Adds joblib support. Allows for advanced memoizing with disk and
# advanced multi-threading techniques.

if (NOT joblib_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_git_repo(joblib
	0.7.1 # 40fc9389c4e18510ba2a19c8bd8502fdbdd7e165
	https://github.com/joblib/joblib)


# Download and install joblib
message ("Installing ${joblib_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${joblib_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${joblib_URL}
    GIT_TAG             ${joblib_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${joblib_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT joblib_NAME)