#!/usr/bin/perl -w
use strict;
use warnings;
my $DEBUG = 0;
my $rsp = " ";
if ( $#ARGV < 0 ) {
	print "Solution must be run as one of the following:\n";
	print "    ./solution.pl quick\n";
	print "    ./solution.pl fsu\n";
	print "    ./solution.pl hello\n";
	print "";
	print "please try again\n";
	exit;
}
my $file = $ARGV[0];
chomp($file);
my $filename = $file . ".txt";
if( ! (-e $filename ) ) {print "$filename not found. \n     Requested file must exist. \n     Try entering hello, quick or fsu\n     Exiting now.\n"; exit;}
#
#	Begin Program
#
#	Read in string
my $s1 = "";
if (open(my $fin, '<', $filename )) {
    while (my $row = <$fin>) {
      chomp $row;
if( $DEBUG == 2 ) { print "$row\n"; }
      $s1 = $s1.$row;
    }
  } else {
    die "Could not open file $filename $!";
  }
#
#	Remove any spaces (they are all fake)
#
if ( $DEBUG == 1 )  { print "$s1" . " \n \n"; }
$s1 =~ s/\s//g;

if( $DEBUG == 1 ) { print "$s1\n\n"; }
#
#	Remove every other character - they are all random
#
my $s2 = "";
for( my $i=1; $i < length $s1; $i=$i+2 ){
	$s2 = $s2.(substr $s1, $i-1,1);
}
if( $DEBUG == 1 ) { print "$s2\n\n"; }
#
#	Replace the XTQ by real spaces
#
$s2 =~ s/XTQ/$rsp/g;
if( $DEBUG == 1)  { print "$s2\n"; }
#
#	Remove every other character - they are all random
#
my $sfinal ="";
for( my $i=1; $i < length $s2; $i=$i+2 ){
	$sfinal = $sfinal.(substr $s2, $i-1,1);
}
#
# Print Final Results
#
print "\n$sfinal\n";
