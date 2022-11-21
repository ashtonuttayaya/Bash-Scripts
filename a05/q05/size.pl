#!/usr/bin/perl
use strict;
my ( $n1, $n2 ) = @ARGV;
my $mb1 = (1.0*$n1)/(1024.0*1024.0);
my $mb2 = (1.0*$n2)/(1024.0*1024.0);
my $cmp = (100.0*$n1)/($n2*1.0);
$mb1 = int($mb1+0.5);
$mb2 = int($mb2+0.5);
$cmp = int($cmp+0.5);

print "$mb1 $mb2 $cmp\n";
exit;
