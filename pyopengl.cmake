#
# Install PyOpenGL from source
#

if (NOT pyopengl_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)

external_source (pyopengl
    3.0.2
    PyOpenGL-3.0.2.tar.gz
    77becc24ffc0a6b28030aa109ad7ff8b
    http://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-3.0.2.tar.gz)

message ("Installing ${pyopengl_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${pyopengl_NAME}
    DEPENDS             ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${pyopengl_URL}
    URL_MD5             ${pyopengl_MD5}
    UPDATE_COMMAND      ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${pyopengl_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyopengl_NAME)
