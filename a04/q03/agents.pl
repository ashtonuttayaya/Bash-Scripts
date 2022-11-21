#!/usr/bin/perl -w
use strict;
use Time::Local;
use Cwd;
#	
#	This code creates a source file that has the mysql commands needed to create the agents file in our database.
#
#	Reserve array for Agent Information
#
my $AGENT_NAME 	= 1;
my $AGENT_DEALERSHIP	= $AGENT_NAME + 1;
my $AGENT_OWNER 	= $AGENT_DEALERSHIP + 1;
my $AGENT_ADDRESS 	= $AGENT_OWNER + 1;
my $AGENT_POPULATION 	= $AGENT_ADDRESS + 1;
my $AGENT_DEALER_ID	= $AGENT_POPULATION + 1;
my $AGENT_SP_ID		= $AGENT_DEALER_ID + 1;
my $AGENT_OWNER_ID	= $AGENT_SP_ID + 1;
my $AGENT_AGENT_ID	= $AGENT_OWNER_ID + 1;
my $AGENT_COUNT;
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
# Read AGENT Data from a tab delimited file.
#
open( IN, "<", "SALESDATA/agents.txt") or die "Can't open agents.txt: $!";
#
#	Loop over the input files
#
while ( my $line = <IN> ) {
	chop( $line );
	@items = split(/\t+/, $line);
#DEBUG	print @items;
#DEBUG	print "\n";
#	$temp[$ind] = [ @items ];
	my $n = 0;
	$temp[$ind][0] = $#items;
	for( my $n = 1; $n <= $#items; $n++ ){
		$temp[$ind][$n] = $items[$n];
#DEBUG		print " $ind $n $temp[$ind][$n] \n";
	}
	$ind++;
}
close( IN ) or die "Can't close agent.txt: $!";
#
#	Store data into remapped AGENT array and then write it out in new format
#
#
#	Create MYSQL file for creating table
#
open ( OUT, ">", "agents.sql") or die " NOT OK - Can't open agents.txt file: $!";

print OUT "USE sales;\n";
print OUT "CREATE TABLE agents(agent_id VARCHAR(9), dealer_id INT, owner_id INT, fname VARCHAR(25), lname VARCHAR(25), primary key(agent_id));\n";

for my $i (0 .. $#temp) {
	( my $lname, my $fname ) = split(/,/, $temp[$i][$AGENT_NAME]);
	$lname = trim($lname);
	$fname = trim($fname);
	my $agent_key = trim($temp[$i][$AGENT_AGENT_ID]);
	my $dealer_id = trim($temp[$i][$AGENT_DEALER_ID]);
	my $boss_id   = trim($temp[$i][$AGENT_OWNER_ID]);
	$k = $i+1;
	print OUT "INSERT INTO agents( agent_id, dealer_id, owner_id, fname, lname ) VALUES( "
	. "\'$agent_key\', \'$dealer_id\', \'$boss_id\', \'$fname\', \'$lname\' );\n";
}

close( OUT ) or die "Can't close agents.sql: $!";
print " OK - file agents.sql created\n";


