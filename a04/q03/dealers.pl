#!/usr/bin/perl -w
# 	This program is used to create to mysql command files from data on dealers and owners.
# 	The resulting files should go into the results subdirectory as:
#		dealers.sql and
#		owners.sql
#
# These are placed in the mysql database using the commands:
#
#		source dealers.sql;
#		soucre owners.sql;
#
#
use strict;
use Time::Local;	# used to manage time - not used in this program
use Cwd;		# used to change working directories - OS independent code
#
#	Reserve array for Dealer Information
#
my $DEALER_NAME 	= 0;
my $DEALER_ID		= $DEALER_NAME + 1;
my $DEALER_ADDRESS 	= $DEALER_ID + 1;
my $DEALER_CITY		= $DEALER_ADDRESS + 1;
my $DEALER_STATE	= $DEALER_CITY + 1;
my $DEALER_OWNER 	= $DEALER_STATE + 1;
my $DEALER_OWNER_ID	= $DEALER_OWNER + 1;
my $DEALER_COUNT;
my @dealers;
my @items;
my @temp;
my $ind = 0;
my $k;
#
#	Create subroutine trim to get rid of trailing and leading blanks
#
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
#
# Read Dealership Data from a tab delimited, exported Excel file - dealerships.txt.
#
#   Begin reading
#
open( IN, "<", "SALESDATA/dealerships.txt") or die "NOT OK - Can't open SALESDATA/dealerships.txt: $!";
my $line = <IN>;		# get the header line at the top and throw it away
#DEBUG	print " $line \n";
#
#	Loop over the input files to get all the dealership information.
#
while ( $line = <IN> ) {
	chop( $line );
	@items = split(/\t/, $line);
	$temp[$ind] = [ @items ];
	$ind++;
}
close( IN ) or die "Can't close dealership.txt: $!";
$DEALER_COUNT = $#temp;		# note index starts at zero goes up from there to DEALER_COUNT
#
#	Store data into remapped dealer array and then write it out in new format
#
open ( OUT, ">", "dealers.sql") or die " NOT OK - Can't open new dealers.sql file: $!";
#
#	Create the database table (NOTE: the DATABASE MUST ALREADY BE CREATED AND THE
#	NECESSARY ACCESS RIGHTS GIVEN USING MYSQL)
#
print OUT  "USE sales;\n";
print OUT  "CREATE TABLE IF NOT EXISTS "
          ." dealers(dealer_id INT, name VARCHAR(50),"
          ." address VARCHAR(50), city VARCHAR(32), state VARChAR(5),"
          ." owner_id INT, primary key(dealer_id));\n";
#
#	Create the insert commands for all the dealerships
#
for my $i (0 .. $#temp) {
	( my $s1, my $s2, my $s3 ) = split(/,/, $temp[$i][1]);
	$dealers[$i][$DEALER_NAME]	= trim($temp[$i][0]);
	$dealers[$i][$DEALER_NAME] 	=~ s/'/_/;
	$dealers[$i][$DEALER_ADDRESS]  	= trim($s1);
	$dealers[$i][$DEALER_CITY]  	= trim($s2);
	$dealers[$i][$DEALER_STATE]  	= trim($s3);
	$dealers[$i][$DEALER_OWNER] 	= trim($temp[$i][2]);
	$dealers[$i][$DEALER_OWNER_ID] 	= trim($temp[$i][4]);
	$k = $i+1;
	print OUT "INSERT INTO dealers(dealer_id,name,address,city,state,owner_id) VALUES( "
	. "\'$k\', \'$dealers[$i][$DEALER_NAME]\', \'$dealers[$i][$DEALER_ADDRESS]\', \'$dealers[$i][$DEALER_CITY]\', "
	. "\'$dealers[$i][$DEALER_STATE]\', \'$dealers[$i][$DEALER_OWNER_ID]\');\n";
}
close( OUT ) or die "Can't close dealers.sql: $!";
#
#	Now create an owners table
#
open ( OUT2, ">", "owners.sql") or die " NOT OK - Can't open new owners.sql file: $!";
print OUT2  "USE sales;\n";
print OUT2 "CREATE TABLE IF NOT EXISTS "
          ." owners(owner_id INT, fname VARCHAR(24),"
          ." lname VARCHAR(24), primary key(owner_id));\n";
#
#	Create the insert commands to put the data in the table
#
for my $i (0 .. $#temp) {
	( my $lname, my $fname ) = split(/,/, $dealers[$i][$DEALER_OWNER] );
	$lname = trim($lname);
	$fname = trim($fname);
#
#	We want only one entry per owner 
#	Some owners own multiple dealerships so we need to chece for that.
#
	my $duplicate = 0;
	for ( my $j = 0; $j < $i; $j++ ) {
		if( $dealers[$j][$DEALER_OWNER_ID] == $dealers[$i][$DEALER_OWNER_ID] ) {
			$duplicate = 1;
			$j = $i;
		}
	}
#
#	Add an insert command only if this is previously unknown owner.
#
	if( $duplicate == 0 ) {
		print OUT2 "INSERT INTO owners(owner_id, fname, lname) VALUES( "
		.          "\'$dealers[$i][$DEALER_OWNER_ID]\', \'$fname\', \'$lname\');\n";
	}
}
close( OUT2 ) or die "Can't close owners.sql: $!";
print " OK - files dealers.sql and owners.sql created.\n";

