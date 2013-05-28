#
# Install scikit-learn library from source
#

if (NOT scikit-learn_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (cython)
include (numpy)
include (scipy)

external_source (scikit-learn
    0.13.1
    scikit-learn-0.13.1.tar.gz
    acba398e1d46274b8470f40d0926e6a4
    http://pypi.python.org/packages/source/s/scikit-learn)

message ("Installing ${scikit-learn_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${scikit-learn_NAME}
    DEPENDS             ${python_NAME} ${cython_NAME} ${numpy_NAME} ${scipy_NAME} 
    PREFIX              ${BUILDEM_DIR}
    URL                 ${scikit-learn_URL}
    URL_MD5             ${scikit-learn_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

set_target_properties(${scikit-learn_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT scikit-learn_NAME)
