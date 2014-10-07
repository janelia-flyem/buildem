#
# Install pgmlink libraries from source
#

if (NOT pgmlink_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

if(CPLEX_ROOT_DIR)
    set(CMAKE_CPLEX_ROOT_DIR "-DCPLEX_ROOT_DIR=${CPLEX_ROOT_DIR}")
endif()

#if ("${CMAKE_CPLEX_ROOT_DIR}" STREQUAL "")
if (NOT CMAKE_CPLEX_ROOT_DIR)
    message ("CPLEX not found.  Pgmlink will not be built.")
    set(pgmlink_NAME "pgmlink-skipped-without-CPLEX")
    set(build_pgmlink 0)
else()
    set(build_pgmlink 1)

    include (python)
    include (ann)
    include (lemon)
    include (vigra)
    include (boost)
    include (opengm)
    include (dlib)
    include (mlpack)
    include (numpy)


    include (cplex-shared)

    external_git_repo (pgmlink
        7a0c8d4f54e9a4066991829fb52b411a02914666
        https://github.com/martinsch/pgmlink)

    message ("Installing ${pgmlink_NAME} into FlyEM build aread: ${BUILDEM_DIR} ...")
    ExternalProject_Add(${pgmlink_NAME}
        DEPENDS             ${ann_NAME} ${lemon_NAME} ${vigra_NAME} ${boost_NAME} ${opengm_NAME} ${numpy_NAME}
                            ${cplex-shared} ${ilocplex-shared} ${concert-shared}
                            ${dlib_NAME} ${mlpack_NAME}
        PREFIX              ${BUILDEM_DIR}
        GIT_REPOSITORY      ${pgmlink_URL}
        GIT_TAG             ${pgmlink_TAG}
        UPDATE_COMMAND      ""
        PATCH_COMMAND       ""
        CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${pgmlink_SRC_DIR} 
            -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
            -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
            -DBUILD_SHARED_LIBS=ON
            -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS}
            -DCMAKE_SHARED_LINKER_FLAGS=${BUILDEM_ADDITIONAL_CXX_FLAGS}
            -DWITH_PYTHON=ON
            -DWITH_TESTS=ON
            -DWITH_CHECKED_STL=OFF
            -DPYTHON_INCLUDE_DIR=${PYTHON_INCLUDE_PATH}
            -DPYTHON_LIBRARY=${PYTHON_LIBRARY_FILE}
            -DVigranumpy_DIR="${BUILDEM_DIR}/lib/vigranumpy"
            ${CMAKE_CPLEX_ROOT_DIR}
    
        BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
        INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
        TEST_COMMAND        ${TEST_STRING}
    )
    
    set_target_properties(${pgmlink_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif()

endif (NOT pgmlink_NAME)
