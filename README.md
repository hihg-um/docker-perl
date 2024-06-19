# Docker / Perl

Author: Sven-Thorsten Dietrich <sxd1425@miami.edu>

This code is made available under the GPL-2.0 license.
Please see the LICENSE file for details.

This container packages perl and can be used as base
for containers running perl scripts.

To run a perl script located in the local directory on your system,
execute the following command:

docker run -it -v "/local/path/to/perl/script:"/app":shared,ro,z \
	hihg-um/perl /app/<perl_script>.pl
