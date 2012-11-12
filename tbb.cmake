#
# Install Intel Threading Building Blocks from source
#

if (NOT tbb_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

external_source (tbb
    20121003
    tbb41_20121003oss_src.tgz
    2a684fefb855d2d0318d1ef09afa75ff
    http://threadingbuildingblocks.org/uploads/77/189/4.1%20update%201/)

message ("Installing ${tbb_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${tbb_NAME}
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${tbb_URL}
    URL_MD5             ${tbb_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set (COPY_SCRIPT ${FLYEM_BUILD_REPO_DIR}/scripts/copy.py)
add_custom_command (TARGET ${tbb_NAME}
    POST_BUILD
    COMMAND python ${COPY_SCRIPT} \"${tbb_SRC_DIR}/build/*_release/*.so\" ${FLYEM_BUILD_DIR}/lib
    COMMAND python ${COPY_SCRIPT} \"${tbb_SRC_DIR}/build/*_release/*.so.*\" ${FLYEM_BUILD_DIR}/lib
    COMMAND python ${COPY_SCRIPT} \"${tbb_SRC_DIR}/include/serial\" ${FLYEM_BUILD_DIR}/include
    COMMAND python ${COPY_SCRIPT} \"${tbb_SRC_DIR}/include/tbb\" ${FLYEM_BUILD_DIR}/include
    COMMENT "Copied Intel threading building blocks library and include files to ${FLYEM_BUILD_DIR}")


endif (NOT tbb_NAME)