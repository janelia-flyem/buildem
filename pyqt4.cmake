#
# Install pyqt4 libraries from source
#

if (NOT pyqt4_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
#include (PatchSupport)

include (python)
include (qt4)
include (sip)

external_source (pyqt4
    4.9.5
    PyQt-mac-gpl-4.9.5.tar.gz
    855f9d9e10821c0f79a7dc956a9a14ec    
    http://iweb.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.9.5)

message ("Installing ${pyqt4_NAME} into FlyEM build area: ${FLYEM_BUILD_DIR} ...")

# MAC OS X config flags!
ExternalProject_Add(${pyqt4_NAME}
    DEPENDS             ${python_NAME} ${sip_NAME} ${qt4_NAME}             
    PREFIX              ${FLYEM_BUILD_DIR}
    URL                 ${pyqt4_URL}
    URL_MD5             ${pyqt4_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ${FLYEM_ENV_STRING} ${PATCH_EXE}
        ${pyqt4_SRC_DIR}/configure.py ${PATCH_DIR}/pyqt4.patch # For some reason, the configure script wants to build pyqt phonon support even if qt was built without it.  This patch simply comments out phonon support.
    CONFIGURE_COMMAND   ${PYTHON_EXE} ${pyqt4_SRC_DIR}/configure.py 
        --confirm-license
        -q "${FLYEM_BUILD_DIR}/bin/qmake"
        --use-arch=x86_64
    BUILD_COMMAND       ${FLYEM_ENV_STRING} make
    INSTALL_COMMAND     ${FLYEM_ENV_STRING} make install
    BUILD_IN_SOURCE 1
)

endif (NOT pyqt4_NAME)

