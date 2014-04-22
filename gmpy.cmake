# Python bindings to the very versatile, established gmp, mpfr, and mpc.
#
# Used by SymPy. Though, can be used independently.


if (NOT gmpy_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (gmp)
include (mpfr)
include (mpc)


external_source (gmpy
    2.0.3
    gmpy2-2.0.3.zip
    63f367b4dceb20dcd72c143e7c9a8632
    http://gmpy.googlecode.com/files/
    FORCE)


message ("Installing ${gmpy_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${gmpy_NAME}
    DEPENDS             ${python_NAME} ${gmp_NAME} ${mpfr_NAME} ${mpc_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${gmpy_URL}
    URL_MD5             ${gmpy_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build --prefix=${BUILDEM_DIR}
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install --prefix=${BUILDEM_DIR}
)

set_target_properties(${gmpy_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT gmpy_NAME)
