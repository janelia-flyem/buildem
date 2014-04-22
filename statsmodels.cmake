# A statistical analysis library that builds on pandas.
#
# Used in pandas place in the SciPy Stack as it requires pandas and extends in
# many ways. 


if (NOT statsmodels_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (cython)
include (nose)
include (numpy)
include (scipy)
include (matplotlib)
include (patsy)
include (pandas)

external_git_repo(statsmodels
	v0.5.0 #82e027e91cac47cfcfbcab754a244731cd726f06
	https://github.com/statsmodels/statsmodels)

message ("Installing ${statsmodels_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${statsmodels_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${nose_NAME} ${numpy_NAME} ${scipy_NAME} ${matplotlib_NAME} ${patsy_NAME} ${pandas_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${statsmodels_URL}
    GIT_TAG             ${statsmodels_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${statsmodels_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT statsmodels_NAME)
