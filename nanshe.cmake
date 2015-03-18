# Activity based segmentation of Calcium image data based on ( dx.doi.org/10.1109/ISBI.2013.6556660 ).

if (NOT nanshe_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (pip)
include (scipy-stack)
include (ilastik)
include (spams-python)
include (rank_filter)
include (cloud_sptheme)
include (pyfftw)


external_git_repo(nanshe
    HEAD
    https://github.com/jakirkham/nanshe)


# Download and install nanshe
message ("Installing ${nanshe_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${nanshe_NAME}
    DEPENDS             ${pip_NAME} ${scipy-stack_NAME} ${ilastik_NAME} ${spams-python_NAME} ${rank_filter_NAME} ${cloud_sptheme_NAME} ${pyfftw_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY      ${nanshe_URL}
    GIT_TAG             ${nanshe_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ""
)

set_target_properties(${nanshe_NAME} PROPERTIES EXCLUDE_FROM_ALL OFF)

endif (NOT nanshe_NAME)
