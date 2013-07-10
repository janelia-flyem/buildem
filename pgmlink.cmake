#
# Install pgmlink libraries from source
#

if (NOT pgmlink_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (PatchSupport)

include (ann)
include (lemon)
include (vigra)
include (boost)
include (opengm)
include (doxygen)

external_git_repo (pgmlink
    HEAD
    https://github.com/ilastik/pgmlink)


message ("Installing ${pgmlink_NAME} into FlyEM build aread: ${BUILDEM_DIR} ...")
ExternalProect_Add(${pgmlink_NAME}
    DEPENDS             ${ann_NAME} ${lemon_NAME} ${vigra_NAME} ${boost_NAME} ${opengm_NAME} ${doxygen_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${pgmlink_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""

    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${pgmlink_SRC_DIR} 
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DWITH_PYTHON=ON
        -DWITH_TESTS=ON
        -DWITH_CHECKED_STL=OFF


    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
    TEST_COMMAND        ${BUILDEM_ENV_STRING} make test
)

set_target_properties(${pgmlink_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pgmlink_NAME)