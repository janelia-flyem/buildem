# A statistical models library. Uses a formula mini-language that is similar to R and S.
# 
# Required by statsmodels, which is used by pandas.
# All dependencies included as already present.


if (NOT patsy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (numpy)
include (scipy)
include (nose)


external_git_repo(patsy
	v0.2.1 #93ee6dcc75f7fd97e4ff46b4cf2688a013c3af40
	https://github.com/pydata/patsy/)


message ("Installing ${patsy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${patsy_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${scipy_NAME} ${nose_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${patsy_URL}
    GIT_TAG             ${patsy_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${patsy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT patsy_NAME)
