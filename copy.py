#!/usr/bin/env python
#
# Copyright 2012 HHMI.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of HHMI nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Author: katzw@janelia.hhmi.org (Bill Katz)
#  Written as part of the FlyEM Project at Janelia Farm Research Center.
"""
Copyright (c) 2012 HHMI. All rights reserved.

See HELP_USAGE below.
"""

from __future__ import with_statement
from collections import defaultdict

import sys
import os
import os.path
import errno
import itertools
import shutil
from glob import iglob

from optparse import OptionParser

sys.path.append(os.path.join('emdata', 'gen-py'))

def make_dir(dirname):
    """
    Make a directory if it doesn't already exist.
    """
    try:
        os.makedirs(dirname)
    except OSError as exc:
        if exc.errno == errno.EEXIST:
            pass
        else:
            raise

def copy_file_or_dir_to_dir(src, dstdir, raise_error=True):
    """
    Copy a file or a directory (recursively) into a dst directory
    """
    try:
        shutil.copytree(src, os.path.join(dstdir, os.path.basename(src)))
    except OSError as exc:
        if exc.errno == errno.ENOTDIR:
            try:
                shutil.copy(src, dstdir)
            except OSError as exc:
                if raise_error:
                    raise
                else:
                    print("*** Could not copy %s to %s" % (src, dstdir))
        elif raise_error:
            raise
        else:
            print("*** Could not copy %s to %s" % (src, dstdir))

def copy_patterns(src, dstdir, raise_error=True):
    """
    Copy files/dirs using string pattern to dst directory
    """
    for fname in iglob(src):
        copy_file_or_dir_to_dir(fname, dstdir, raise_error)


def dir_exists_in_path_list(dirname, path_list):
    """
    Return True if a given directory exists in any path in path_list
    """
    for cur_path in path_list:
        target_path = os.path.join(cur_path, dirname)
        if os.path.exists(target_path):
            return True
    return False


HELP_USAGE = """
%prog will recursively copy files from a source pattern string to dst directory.

    %prog <src> <dst>

Example:

    %prog "/my/src/dir/*" /my/dst/dir
"""

def main():
    parser = OptionParser(usage=HELP_USAGE)
    (options, args) = parser.parse_args()

    if len(args) != 2:
        print("\nERROR!! Must specify only source and destination patterns.\n\n")
        parser.print_help()
        sys.exit(2)

    src = args[0]
    dst = args[1]
    print("Copying %s to %s ..." % (src, dst))
    copy_patterns(src, dst)

    
if __name__ == '__main__':
    main()

