#!/bin/bash

BOOST_SRC_DIR=$1
CXX_COMPILER=$2
CXX_COMPILER_VERSION=`$2 -dumpversion | sed -e 's/\.[0-9]$//g'`

echo "Configuring Boost to compile with ${CXX_COMPILER}"

echo "" >> ${BOOST_SRC_DIR}/tools/build/v2/user-config.jam
echo "using darwin : ${CXX_COMPILER_VERSION} : ${CXX_COMPILER} ;" >> ${BOOST_SRC_DIR}/tools/build/v2/user-config.jam
echo "" >> ${BOOST_SRC_DIR}/tools/build/v2/user-config.jam