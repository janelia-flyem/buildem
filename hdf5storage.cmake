#
# A python module to provide additional support for the HDF5 format.
# Is able to load and save MATLAB v7.3 file. Will fallback to SciPy when it is unable to.
#


if (NOT hdf5storage_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

include (python)
include (numpy)
include (h5py)
include (scipy)

external_source (hdf5storage
# Run the fake file using echo to initialize the shell.
    0.1.3
    hdf5storage-0.1.3.zip
    1bdda81bd88ce2f23adbda0217e16375
    https://pypi.python.org/packages/source/h/hdf5storage/)


# Download and install hdf5storage
message ("Installing ${hdf5storage_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${hdf5storage_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${h5py_NAME} ${scipy_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${hdf5storage_URL}
    URL_MD5             ${hdf5storage_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${hdf5storage_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT hdf5storage_NAME)

