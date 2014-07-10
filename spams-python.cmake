#
# Install spams-python from source
#

if (NOT spams-python_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

external_source (spams-python
    2.4
	spams-python-v2.4-svn2014-03-27.tar.gz
	57b4851bf2d623fc8a23d0fd4c204694
    http://spams-devel.gforge.inria.fr/hitcounter2.php?file=33494/)

message ("Installing ${spams-python_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${spams-python_NAME}
    DEPENDS             ${atlas_NAME} ${python_NAME} ${setuptools_NAME} ${numpy_NAME} ${scipy_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${spams-python_URL}
    URL_MD5             ${spams-python_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${BUILDEM_ENV_STRING} ${PATCH_EXE}
        # Patches SPAMS in a way where we are sure it will run.
	
	# The first patch should work with any LAPACK and BLAS implementation.
        ${spams-python_SRC_DIR}/setup.py ${PATCH_DIR}/spams-python-setup.patch
	# If you wish to use the tuned ATLAS library as well, use this patch.
    	#${spams-python_SRC_DIR}/setup.py ${PATCH_DIR}/spams-python-setup-atlas.patch

    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${spams-python_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT spams-python_NAME)

