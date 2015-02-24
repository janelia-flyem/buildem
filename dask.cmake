# Provides dask, an implementation to support larger than memory arrays that can be used as NumPy ndarrays.

if (NOT dask_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (dill)
include (cytoolz)
include (toolz)

external_git_repo(dask
	0.2.6 #af03c7c7d7cc5e06701fd2f5153008f367ed99fe
	https://github.com/ContinuumIO/dask)


# Download and install dask
message ("Installing ${dask_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${dask_NAME}
    DEPENDS             ${python_NAME} ${dill_NAME} ${cytoolz_NAME} ${toolz_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${dask_URL}
    GIT_TAG             ${dask_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${dask_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT dask_NAME)
