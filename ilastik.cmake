#
# Install ilastik from source
#
# Ilastik is composed of 3 git repos, 2 of which are necessary for headless mode.
#
# lazyflow
# applet-workflows
# volumina (for gui builds)
#
# Also, you must build lazyflow/lazyflow/drtile with CMake to produce drtile.so shared library.
# This is done in the CONFIGURE_COMMAND below and the shared library is saved in the
# drtile source directory.

if (NOT ilastik_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (vigra)
include (h5py)
include (psutil)
include (blist)
include (greenlet)

external_git_repo (ilastik
    HEAD
    http://github.com/janelia-flyem/ilastik-flyem)

message ("Installing ${ilastik_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
ExternalProject_Add(${ilastik_NAME}
    DEPENDS             ${vigra_NAME} ${blist_NAME} ${greenlet_NAME} 
    PREFIX              ${FLYEM_BUILD_DIR}
    GIT_REPOSITORY      ${ilastik_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ${FLYEM_ENV_STRING} ${CMAKE_COMMAND}
        -DLIBRARY_OUTPUT_PATH=${ilastik_SRC_DIR}/lazyflow/lazyflow/drtile
        -DCMAKE_PREFIX_PATH=${FLYEM_BUILD_DIR}
        -DVIGRA_ROOT=${FLYEM_BUILD_DIR}
        ${ilastik_SRC_DIR}/lazyflow/lazyflow/drtile
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy drtile.so ${FLYEM_BUILD_DIR}/lib
)

# Create script files
ExternalProject_add_step(${ilastik_NAME}  install_ilastik_gui
    DEPENDEES   download
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_gui.template
        ${FLYEM_BUILD_DIR}/bin/ilastik_gui
        ${FLYEM_BUILD_DIR}
        ${ilastik_SRC_DIR}
    COMMENT     "Added ilastik gui command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_ilastik_headless
    DEPENDEES   download
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_headless.template
        ${FLYEM_BUILD_DIR}/bin/ilastik_headless
        ${FLYEM_BUILD_DIR}
        ${ilastik_SRC_DIR}
    COMMENT     "Added ilastik headless command to bin directory"
)


endif (NOT ilastik_NAME)

