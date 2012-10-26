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

if (NOT ilastik_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (vigra)
include (blist)
include (greenlet)

message ("Installing ilastik-flyem into FlyEM build area: ${FLYEM_BUILD_DIR} ...")
external_git_repo (ilastik-flyem
    HEAD
    http://github.com/janelia-flyem/ilastik-flyem)

ExternalProject_Add(${ilasik_NAME}
    DEPENDS             ${vigra_NAME} ${blist_NAME} ${greenlet_NAME} 
    PREFIX              ${FLYEM_BUILD_DIR}
    GIT_REPOSITORY      ${ilastik_URL}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    LIST_SEPARATOR      ^^
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${FLYEM_ENV_STRING} ${CMAKE_COMMAND} 
        {ilastik_SRC_DIR}/lazyflow/lazyflow/drtile
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${CMAKE_COMMAND} -E copy drtile.so ${FLYEM_BUILD_DIR}/lib
)

# Create script files
ExternalProject_add_step(ilastik-flyem  install_ilastik_gui
    DEPENDEES   download
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_gui.template
        ${FLYEM_BUILD_DIR}/bin/ilastik_gui
        ${FLYEM_BUILD_DIR}
        ${ilastik_SRC_DIR}
    COMMENT     "Added ilastik gui command to bin directory"
)

ExternalProject_add_step(ilastik-flyem  install_ilastik_headless
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

