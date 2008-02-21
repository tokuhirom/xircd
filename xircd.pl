#!/usr/bin/perl
use strict;
use warnings;
use File::Spec::Functions;
use FindBin;
use lib catfile($FindBin::Bin, 'lib');
use XIRCD;

XIRCD->bootstrap;
