# Provides Python bindings for ZeroMQ.
# Required for iPython.

if (NOT pyzmq_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)
include(zeromq)


external_git_repo(pyzmq
	v14.0.1 # 28b5bef764cbe87518b589df54f6f7f5ed50964d
	https://github.com/zeromq/pyzmq)


message ("Installing ${pyzmq_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${pyzmq_NAME}
    DEPENDS             ${python_NAME} ${zeromq_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${pyzmq_URL}
    GIT_TAG             ${pyzmq_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py configure --zmq=${BUILDEM_DIR}
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pyzmq_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyzmq_NAME)