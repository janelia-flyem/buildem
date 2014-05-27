#
# Install scikit-image library from source
#

if (NOT scikit-image_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (cython)
include (numpy)
include (scipy)

external_source (scikit-image
    0.9.3
    scikit-image-0.9.3.tar.gz
    f010e0cd46ee2996a6875c96b216e768
    https://pypi.python.org/packages/source/s/scikit-image)

message ("Installing ${scikit-image_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${scikit-image_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${scikit-image_URL}
    URL_MD5             ${scikit-image_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scikit-image_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scikit-image_NAME)
