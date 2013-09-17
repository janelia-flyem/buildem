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

set (ilastik-gui_NAME ${ilastik_NAME}-gui)

# Add a few dependencies to GUI ilastik build
add_dependencies( ${ilastik_NAME} ${qt4_NAME} ${pyqt4_NAME} ${qimage2ndarray_NAME} ${vtk_NAME} ) 

add_custom_target (${ilastik-gui_NAME} ALL 
    DEPENDS     ${ilastik_NAME}
    COMMENT     "Building ilastik gui and all dependencies...")

# Add environment setting script
set(SETENV_ILASTIK setenv_ilastik_gui)
configure_file(${TEMPLATE_DIR}/${SETENV_ILASTIK}.in ${BUILDEM_DIR}/bin/${SETENV_ILASTIK}.sh @ONLY)

# Add gui launch script
set(LAUNCH_ILASTIK ilastik/ilastik.py)
configure_file(${TEMPLATE_DIR}/ilastik_script.template ${BUILDEM_DIR}/bin/ilastik_gui @ONLY)

# Add gui test script
set(LAUNCH_ILASTIK ilastik/tests/test_applets/pixelClassification/testPixelClassificationGui.py)
configure_file(${TEMPLATE_DIR}/ilastik_script.template ${BUILDEM_DIR}/bin/ilastik_gui_test @ONLY)

# Run the gui test script after the ilastik-gui target is built
add_custom_command (
    TARGET     ${ilastik-gui_NAME}
    POST_BUILD
    COMMAND     ${BUILDEM_ENV_STRING} ${BUILDEM_DIR}/bin/ilastik_gui_test
    COMMENT     "Running ilastik gui test"
)

endif (NOT ilastik-gui_NAME)

