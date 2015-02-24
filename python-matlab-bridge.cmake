# Provides a simple and fast interface to MATLAB from Python using zmq.

if (NOT python-matlab-bridge_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)
include (pyzmq)
include (ipython)


external_git_repo(python-matlab-bridge
	0.3 #a6fd3cc3adf5ef2b5e3d9b83a8050d783c76d48f
	https://github.com/arokem/python-matlab-bridge)

message ("Installing ${python-matlab-bridge_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${python-matlab-bridge_NAME}
    DEPENDS             ${python_NAME} ${pyzmq_NAME} ${ipython_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${python-matlab-bridge_URL}
    GIT_TAG             ${python-matlab-bridge_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${python-matlab-bridge_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT python-matlab-bridge_NAME)
