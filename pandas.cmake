# Data analysis (primarily linear) for Python. Part of the SciPy Stack.
# 
# Includes essential dependencies and optional ones that were already included.
# Optional ones have not been included (i.e. Any data reading stuff Excel, Amazon, PyTables) or fancy HTML parsers (i.e. BeautifulSoupX).
# Required by statsmodels.


if (NOT pandas_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (cython)
include (python-dateutil)
include (pytz)
include (numpy)
include (scipy)
include (matplotlib)
include (numexpr)
include (bottleneck)


external_git_repo(pandas
	v0.12.0 #8c0a34f15f8a87def3f7ad6ebdac052de44669f2
	https://github.com/pydata/pandas)


message ("Installing ${pandas_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${pandas_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${python-dateutil_NAME} ${pytz_NAME} ${numpy_NAME} ${scipy_NAME} ${matplotlib_NAME} ${numexpr_NAME} ${bottleneck_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${pandas_URL}
    GIT_TAG             ${pandas_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pandas_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pandas_NAME)
