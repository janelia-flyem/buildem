# Provides support for FFTW from Python.


if (NOT pyfftw_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (libfftw)
include (python)
include (numpy)
include (scipy)
include (cython)

external_git_repo(pyfftw
	v0.9.2 #94375708a8a6a0112f0c76e5e1467a17cf4a6a02
	https://github.com/hgomersall/pyFFTW)


# Download and install pyfftw
message ("Installing ${pyfftw_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${pyfftw_NAME}
    DEPENDS             ${libfftw_NAME} ${python_NAME} ${numpy_NAME} ${scipy_NAME} ${cython_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${pyfftw_URL}
    GIT_TAG             ${pyfftw_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
                            # Patches PyFFTW to ensure that it uses includes and libraries from the right place.
                            ${pyfftw_SRC_DIR}/setup.py ${PATCH_DIR}/pyfftw-setup.py.patch
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       BUILDEM_DIR=${BUILDEM_DIR} ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     BUILDEM_DIR=${BUILDEM_DIR} ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pyfftw_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pyfftw_NAME)
