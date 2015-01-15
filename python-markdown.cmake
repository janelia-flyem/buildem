# Adds python-markdown, a markdown parser.

if (NOT python-markdown_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (setuptools)

external_git_repo(python-markdown
	2.5.2-final # a9195fd2261d8a29762f7d8fc34b520c94fd09ec
	https://github.com/waylan/Python-Markdown)


# Download and install python-markdown
message ("Installing ${python-markdown_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${python-markdown_NAME}
    DEPENDS             ${python_NAME} ${setuptools_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${python-markdown_URL}
    GIT_TAG             ${python-markdown_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${python-markdown_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python-markdown_NAME)
