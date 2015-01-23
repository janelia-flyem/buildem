# Provides symbolic algebra support for Python. Part of the SciPy stack.


if (NOT sympy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (cython)
include (gmpy)
include (numpy)
include (scipy)
include (ipython)

external_git_repo(sympy
	sympy-0.7.3 #f44c2c6afb1eaf5f1071b49bcd147e0d6197923a
	https://github.com/sympy/sympy)

message ("Installing ${sympy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${sympy_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${gmpy_NAME} ${numpy_NAME} ${scipy_NAME} ${ipython_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${sympy_URL}
    GIT_TAG             ${sympy_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${sympy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT sympy_NAME)
