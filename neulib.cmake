#
# Install libneurolabi from source
#

if (NOT libneurolabi_NAME)

  include(${BUILDEM_REPO_DIR}/neulib_com.cmake)

  SET(config_args --enable-shared) 
  SET(depends_args libjansson libfftw libxml2 libjansson libpng zlib) 
  INSTALL_NEULIB(libneurolabi "${config_args}")

endif (NOT libneurolabi_NAME)
