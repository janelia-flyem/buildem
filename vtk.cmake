#
# Install vtk libraries from source
#

if (NOT vtk_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include (python)
include (qt4)
include (sip)
include (pyqt4)

external_source (vtk
    5.10.1
    vtk-5.10.1.tar.gz
    264b0052e65bd6571a84727113508789
    http://www.vtk.org/files/release/5.10)

message ("Installing ${vtk_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${vtk_NAME}
    DEPENDS             ${python_NAME} ${qt4_NAME} ${sip_NAME} ${pyqt4_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${vtk_URL}
    URL_MD5             ${vtk_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ${BUILDEM_ENV_STRING} ${CMAKE_COMMAND} ${vtk_SRC_DIR}
        -DCMAKE_INSTALL_PREFIX=${BUILDEM_DIR}
        -DBUILD_SHARED_LIBS:BOOL=ON
        # These python settings must be manually specified for the mac build (maybe not for linux, but it shouldn't hurt)
        -DVTK_PYTHON_SETUP_ARGS=--prefix=${PYTHON_PREFIX}
        -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY_FILE}
        -DSIP_EXECUTABLE:FILEPATH=${PYTHON_PREFIX}/bin/sip
        -DSIP_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_PATH}
        -DSIP_PYQT_DIR:PATH=${PYTHON_PREFIX}/share/sip/PyQt4
        -DVTK_WRAP_PYTHON:BOOL=ON
        -DVTK_WRAP_PYTHON_SIP:BOOL=ON
        # ilastik uses QT VTK widgets
        -DVTK_USE_QT:BOOL=ON
        -DVTK_USE_QVTK_QTOPENGL:BOOL=ON
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} make
    #TEST_COMMAND        ${BUILDEM_ENV_STRING} make check
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} make install
)

set_target_properties(${vtk_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT vtk_NAME)
