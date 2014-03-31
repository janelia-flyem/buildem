#
# Install opengm libraries from source
#

if (NOT opengm_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (boost)
include (hdf5)
include (python)

external_git_repo (opengm
    576dc472324a5dce40b7e9bb4c270afbd9b3da37
    https://github.com/opengm/opengm)

if(CPLEX_ROOT_DIR)
    set(CMAKE_CPLEX_ROOT_DIR "-DCPLEX_ROOT_DIR=${CPLEX_ROOT_DIR}")
endif()

message ("Installing ${opengm_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${opengm_NAME}
    DEPENDS             ${boost_NAME} ${hdf5_NAME} ${python_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${opengm_URL}
    GIT_TAG             ${opengm_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${opengm_SRC_DIR} 
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DWITH_CPLEX=ON
        -DWITH_BOOST=ON
        -DWITH_HDF5=ON
        -DBUILD_PYTHON_WRAPPER=ON
        -DWITH_OPENMP=OFF # Mac doesn't support OpenMP
        ${CMAKE_CPLEX_ROOT_DIR}

    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) test
)

set_target_properties(${opengm_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT opengm_NAME)
