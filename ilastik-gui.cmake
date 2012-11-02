#
# Install ilastik GUI from source
#
# Ilastik is composed of 3 git repos, 2 of which are necessary for headless mode.
# The GUI build supplements the ilastik headless build with a number of components
# and also adds some environment setting, launch, and test scripts to the bin
# directory.

if (NOT ilastik-gui_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (ilastik)
include (qt4)
include (pyqt4)
include (qimage2ndarray)
include (vtk)

set (ilastik-gui_NAME ilastik-gui-HEAD)

# Add a few dependencies to headless ilastik build
add_custom_target (${ilastik-gui_NAME} ALL 
    DEPENDS     ${ilastik_NAME} ${qt4_NAME} ${pyqt4_NAME} {qimage2ndarray_NAME}
                ${vtk_NAME}
    COMMENT     "Building ilastik gui and all dependencies...")
    

# Add environment setting script
ExternalProject_add_step(${ilastik_NAME}  install_gui_env_script
    DEPENDEES   download
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/setenv_ilastik_gui.template
        ${FLYEM_BUILD_DIR}/bin/setenv_ilastik_gui.sh
        ${FLYEM_BUILD_DIR}
        ${ilastik_SRC_DIR}
    COMMENT     "Added ilastik gui environment script to bin directory"
)

# Add headless launch and test scripts
ExternalProject_add_step(${ilastik_NAME}  install_gui_launch
    DEPENDEES   install_gui_env_script
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${FLYEM_BUILD_DIR}/bin/ilastik_gui
        ${FLYEM_BUILD_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/workflows/pixelClassification/pixelClassificationWorkflowMainGui.py
    COMMENT     "Added ilastik gui command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_gui_test
    DEPENDEES   install_gui_launch
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${FLYEM_BUILD_DIR}/bin/ilastik_gui_test
        ${FLYEM_BUILD_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/tests/test_applets/pixelClassification/testPixelClassificationGui.py
    COMMENT     "Added ilastik gui test command to bin directory"
)

endif (NOT ilastik-gui_NAME)

