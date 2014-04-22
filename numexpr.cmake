# An acceleration library for use with NumPy.
#
# Used by pandas. However, it is useful by itself.


if (NOT numexpr_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (numpy)
include (scipy)
include (nose)

external_git_repo(numexpr
	v2.3.1 #aba0e0a1ff1edc4cc8c82024dee1693c06aa1336
	https://github.com/pydata/numexpr)

message ("Installing ${numexpr_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${numexpr_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${numexpr_URL}
    GIT_TAG             ${numexpr_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        "" # Would like to run this test however. Import doesn't necessarily work during build. ${BUILDEM_ENV_STRING} ${PYTHON_EXE} -c "import numexpr; numexpr.test()"
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${numexpr_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT numexpr_NAME)
