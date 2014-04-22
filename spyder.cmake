# A MATLAB styled IDE for Python.
#
# Would be nice if this worked. However, it requires QtWebKit, which is currently broken. QtWebKit does not build cleanly and may require patches to Qt and/or PyQt.
# 


message(FATAL_ERROR "Spyder does not currently work. Though it can build, it requires features from Qt and PyQt that are not currently supported. In particular, it needs to QtWebKit.")


if (NOT spyder_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)
include (pep8)
include (pyqt4)
include (sphinxcontrib-napoleon)    # Nice Sphinx docs
include (nose)
include (rope)
include (pyflakes)
include (pygments)
include (pylint)
include (psutil)
include (ipython)


external_source (spyder
    2.2.5
    spyder-2.2.5.zip
    1c9aa650dae9f883616e917803f8a3be
    https://bitbucket.org/spyder-ide/spyderlib/downloads)


# Download and install spyder
message ("Installing ${spyder_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")

ExternalProject_Add(${spyder_NAME}
    DEPENDS             ${python_NAME} ${pep8_NAME} ${pyqt4_NAME} ${sphinxcontrib-napoleon} ${nose_NAME} ${rope_NAME} ${pyflakes_NAME} ${pygments_NAME} ${pylint_NAME} ${psutil_NAME} ${ipython_NAME}
    PREFIX              ${BUILDEM_DIR}
    URL                 ${spyder_URL}
    URL_MD5             ${spyder_MD5}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build
    BUILD_IN_SOURCE     1
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${spyder_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT spyder_NAME)