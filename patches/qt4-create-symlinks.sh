#!/bin/bash

BUILDEM_DIR=$1
FRAMEWORKS=$(ls ${BUILDEM_DIR}/lib | grep framework$)

for i in ${FRAMEWORKS} 
do 
	ln -s ${BUILDEM_DIR}/lib/$i/Headers ${BUILDEM_DIR}/include/`echo \$i | sed 's/.framework//g'`
done