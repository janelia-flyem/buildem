# Standard of Python interactive programming.
# Required by Spyder.

if (NOT ipython_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)
include (pyqt4)
include (sphinxcontrib-napoleon)  # For sphinx extension. Doesn't necessarily need napolean, but it is nice to have and is quick to install.
include (pyzmq)
include (nose)
include (pygments)
include (tornado)
include (jinja)


external_git_repo(ipython
	rel-2.1.0 #681fd77d0aa43f0b2648674ce3da9185021c0e3d
	https://github.com/ipython/ipython/)

message ("Installing ${ipython_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${ipython_NAME}
    DEPENDS             ${python_NAME} ${sphinxcontrib-napoleon_NAME} ${pyzmq_NAME} ${nose_NAME} ${pygments_NAME} ${tornado_NAME} ${jinja_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${ipython_URL}
    GIT_TAG             ${ipython_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${ipython_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT ipython_NAME)
