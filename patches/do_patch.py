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
do_patch

Apply a series of patches

See HELP_USAGE below.
"""

import sys
import os
import os.path

from optparse import OptionParser

HELP_USAGE = """
%prog applies a series of patches

    %prog file1 patch1 [file2 patch2...]

"""

def main():
    parser = OptionParser(usage=HELP_USAGE)
    (options, args) = parser.parse_args()

    num_patches = len(args) / 2
    print("\nApplying %d patches...\n" % num_patches)

    pwd = os.path.dirname(__file__)
    sys.path.append(pwd)
    for i in range(num_patches):
        cmd = "patch -N " + args[i*2] + " " + os.path.join(pwd, args[i*2+1])
        print("Applying " + cmd)
        retcode = os.system(cmd)
        if retcode != 0:
            sys.stderr.write( "Failed patch command #{}: {}".format(i*2+1, cmd) )
            return retcode
    return 0

if __name__ == '__main__':
    sys.exit( main() )

