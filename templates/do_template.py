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
do_template

Use a template and supplied command-line parameters to generate a file

See HELP_USAGE below.
"""

from __future__ import with_statement

import sys
import os
import os.path
import stat

from optparse import OptionParser

HELP_USAGE = """
%prog applies a series of parameters on the command-line to a template
and stores the result into a file

    %prog [options] template dst [params ...]

"""

def main():
    parser = OptionParser(usage=HELP_USAGE)
    parser.add_option("--exe", dest="set_exe", default=False,
                      action="store_true", help="set executable bits")
    (options, args) = parser.parse_args()

    pwd = os.path.dirname(__file__)
    template_path = os.path.join(pwd, args[0])
    try:
        with open(template_path, 'r') as f:
            if len(args) > 2:
                text = f.read().format(*args[2:])
            else:
                text = f.read()
        try:
            with open(args[1], 'w') as f:
                f.write(text)
            print("Wrote file %s after applying parameters to template %s." % \
                (args[1], template_path))
            if options.set_exe:
                perm_bits = stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH |
                            stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
                os.chmod(args[1], perm_bits)
        except IOError:
            print("Could not write or set permissions on file %s ... aborting program" % args[1])
            sys.exit(2)
    except IOError:
        print("Could not open template %s ... aborting program" % template_path)
        sys.exit(2)


if __name__ == '__main__':
    main()

