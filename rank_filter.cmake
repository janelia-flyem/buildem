#
# Install rank_filter module from source
#

if (NOT rank_filter_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)

set(DISABLE_VIGRANUMPY 0)

include (python)
include (numpy)
include (boost)
include (vigra)
include (nose)

external_git_repo (rank_filter
    v0.1
    https://github.com/jakirkham/rank_filter)

message("Installing ${rank_filter_NAME}/${VIGRA_VERSION} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${rank_filter_NAME}
    DEPENDS             ${python_NAME} ${numpy_NAME} ${boost_NAME} ${vigra_NAME} ${nose_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${rank_filter_URL}
    GIT_TAG             ${rank_filter_TAG}
    PATCH_COMMAND       ""
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${rank_filter_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DCMAKE_PREFIX_PATH=${BUILDEM_DIR}
        -DCMAKE_EXE_LINKER_FLAGS=${BUILDEM_LDFLAGS}
        -DDEPENDENCY_SEARCH_PREFIX=${BUILDEM_DIR}
        -DBOOST_ROOT=${BUILDEM_DIR}
        -DVIGRA_ROOT=${BUILDEM_DIR}
        "-DCMAKE_CXX_FLAGS=-pthread ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
        "-DCMAKE_CXX_LINK_FLAGS=-pthread ${BUILDEM_ADDITIONAL_CXX_FLAGS}"
        -DCMAKE_CXX_FLAGS_RELEASE=-O2\ -DNDEBUG
        -DCMAKE_CXX_FLAGS_DEBUG="${CMAKE_CXX_FLAGS_DEBUG}"
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} $(MAKE)
    TEST_COMMAND        ${BUILDEM_ENV_STRING} $(MAKE) test
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} $(MAKE) install
)

set_target_properties(${rank_filter_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT rank_filter_NAME)

