# Pseudo-package for installing the full SciPy stack.

if (NOT scipy-stack_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

set(scipy-stack_NAME "scipy-stack")

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)


include (python)
include (sphinxcontrib-napoleon)    # Nice Sphinx docs
include (pyqt4)
include (numpy)
include (scipy)
include (matplotlib)
include (statsmodels)  # Includes pandas as a dependency
include (scikit-image)
include (scikit-learn)
include (sympy)         # Pulls in gmpy2
include (ipython)
include (nose)


ExternalProject_Add(${scipy-stack_NAME}
    DEPENDS             ${python_NAME} ${sphinxcontrib-napoleon_NAME} ${pyqt4_NAME} ${numpy_NAME} ${scipy_NAME} ${matplotlib_NAME} ${statsmodels_NAME} ${scikit-image_NAME} ${scikit-learn_NAME} ${sympy_NAME} ${ipython_NAME} ${nose_NAME}
    DOWNLOAD_COMMAND    ""
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ""
    TEST_COMMAND        ""
    INSTALL_COMMAND     ""
)

endif (NOT scipy-stack_NAME)