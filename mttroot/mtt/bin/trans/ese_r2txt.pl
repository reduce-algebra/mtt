#! /usr/bin/perl -w

use strict;

$/ = ';';			# statements are terminated by ;
while (<STDIN>) {
    chomp;
    s/%.*\n//g;			# strip comments (% to end of line)
    s/(\s)*//g;			# strip whitespace
    s/^END$//;			# strip junk
    next if /^(\s)*$/;		# skip blank lines
    printf ("%s\n", $_);	# print what remains
}
