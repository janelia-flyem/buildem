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
include (chatty)
include (cylemon)

set (ilastik-gui_NAME ${ilastik_NAME}-gui)

# Add a few dependencies to GUI ilastik build
add_dependencies( ${ilastik_NAME} ${qt4_NAME} ${pyqt4_NAME} ${qimage2ndarray_NAME} ${vtk_NAME} ${chatty_NAME} ${cylemon_NAME} ) 

add_custom_target (${ilastik-gui_NAME} ALL 
    DEPENDS     ${ilastik_NAME}
    COMMENT     "Building ilastik gui and all dependencies...")

# Add environment setting script
ExternalProject_add_step(${ilastik_NAME}  install_gui_env_script
    DEPENDEES   test
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/setenv_ilastik_gui.template
        ${BUILDEM_DIR}/bin/setenv_ilastik_gui.sh
        ${BUILDEM_LD_LIBRARY_VAR}
        ${BUILDEM_DIR}
        ${ilastik_SRC_DIR}
        ${PYTHON_PREFIX}
    COMMENT     "Added ilastik gui environment script to bin directory"
)

# Add gui launch and test scripts
ExternalProject_add_step(${ilastik_NAME}  install_gui_launch
    DEPENDEES   install_gui_env_script
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_gui
        ${BUILDEM_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/workflows/pixelClassification/pixelClassificationWorkflowMainGui.py
    COMMENT     "Added ilastik gui command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_gui_ws_launch # Alternate GUI that includes watershed
    DEPENDEES   install_gui_env_script
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_gui_ws
        ${BUILDEM_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/workflows/vigraWatershed/pixelClassificationWithWatershedMain.py
    COMMENT     "Added ilastik gui-ws command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_gui_carving_launch # Alternate GUI: Carving workflow
    DEPENDEES   install_gui_env_script
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_gui_carving
        ${BUILDEM_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/workflows/carving/carving.py
    COMMENT     "Added ilastik gui-carving command to bin directory"
)

ExternalProject_add_step(${ilastik_NAME}  install_gui_test
    DEPENDEES   install_gui_launch
    COMMAND     ${TEMPLATE_EXE}
        --exe
        ${TEMPLATE_DIR}/ilastik_script.template
        ${BUILDEM_DIR}/bin/ilastik_gui_test
        ${BUILDEM_DIR}/bin/setenv_ilastik_gui.sh
        ${ilastik_SRC_DIR}/ilastik/tests/test_applets/pixelClassification/testPixelClassificationGui.py
    COMMENT     "Added ilastik gui test command to bin directory"
)

# Run the gui test script
ExternalProject_add_step(${ilastik_NAME} test_ilastik_gui
    DEPENDEES   install_gui_test
    COMMAND     ${BUILDEM_ENV_STRING} ${BUILDEM_DIR}/bin/ilastik_gui_test
    COMMENT     "Ran ilastik gui test"
)

endif (NOT ilastik-gui_NAME)

