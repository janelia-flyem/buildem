# Python image library fork.


if (NOT pillow_NAME)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

include (ExternalProject)
include (ExternalSource)
include (BuildSupport)
include (TemplateSupport)

include (python)
include (zlib)
include (libjpeg)
include (libtiff)
include (freetype2)
include (numpy)

external_git_repo(pillow
	2.7.0 # 0f05eb287a223ce106848cd048cfcb45e9faa565
	https://github.com/python-pillow/pillow)

message ("Installing ${pillow_NAME} into FlyEM build area: ${BUILDEM_DIR} ...")
ExternalProject_Add(${pillow_NAME}
    DEPENDS             ${python_NAME} ${zlib_NAME} ${libjpeg_NAME} ${libtiff_NAME} ${freetype2_NAME} ${numpy_NAME}
    PREFIX              ${BUILDEM_DIR}
    GIT_REPOSITORY	${pillow_URL}
    GIT_TAG             ${pillow_TAG}
    UPDATE_COMMAND      ""
    PATCH_COMMAND       ""
    CONFIGURE_COMMAND   ""
    # It would be nice to ensure libraries we don't provide aren't used with these options, but they appear not to work.
    BUILD_COMMAND       ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py build # --disable-tcl --disable-tk --disable-lcms --disable-webp --disable-webpmux --disable-jpeg2000
    BUILD_IN_SOURCE     1
    TEST_COMMAND        ""
    INSTALL_COMMAND     ${BUILDEM_ENV_STRING} ${PYTHON_EXE} setup.py install
)

set_target_properties(${pillow_NAME} PROPERTIES EXCLUDE_FROM_ALL ON)

endif (NOT pillow_NAME)
