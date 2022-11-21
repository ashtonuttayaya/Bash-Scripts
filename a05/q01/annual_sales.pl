#!/usr/bin/perl -w
use strict;
use Time::Local;
use Cwd;
my $DEBUG=0;
#
#	Makes changes to deal with bad perl install
#
# Generic Information on data
#
my $YEAR_MIN = 2010;
my $YEAR_MAX = 2015;
#
#
#	Define information needed for mysql
my $platform = "mysql";
my $database = "sales";
my $host     = "localhost";
my $port     = "3306";
my $tablename = "agents";				# we will access multiple tables
my $user     = $ENV{'MYSQL_USER'};
my $password = $ENV{'MYSQL_PASS'};
my $datapath = $ENV{'MYSQL_DATA'};

# if( (! defined $ENV{'MYSQL_USER'}) || (! defined $ENV{'MYSQL_PASS'})  || (! defined $ENV{'MYSQL_DATA'} ) ) {
#
#	print "You need to set the environment variables MYSQL_USER, MYSQL_PASS and MYSQL_DATA\n";
#	print "Stopping until they are set\n";
#	exit;
# }
#
#	Define and reserve the array for SALES information
#

my @sales;							# Array to hold sales data
								# Recall the number of sales, ie, SALES COUNT = $#sales
my $SALE_TYPE 			= 0;				# can be new or used
my $SALE_ID 			= $SALE_TYPE + 1;		# Sales ID number
my $SALE_DID			= $SALE_ID + 1;			# Dealership ID
my $SALE_OID			= $SALE_DID + 1;		# Owner ID
my $SALE_AGENT			= $SALE_OID + 1;		# Sales agent ID
my $SALE_VIN			= $SALE_AGENT + 1;		# Vehicle ID Number
my $SALE_PRICE_SOLD		= $SALE_VIN + 1;		# Sales price
my $SALE_PRICE_LIST		= $SALE_PRICE_SOLD + 1;		# List price
my $SALE_DEALER_COST	 	= $SALE_PRICE_LIST + 1;		# Cost to the dealer
my $SALE_YEAR			= $SALE_DEALER_COST + 1;	# Year the sale is made in YYYY format
my $SALE_MONTH			= $SALE_YEAR + 1;		# Month the sale is made in MM format
my $SALE_DAY			= $SALE_MONTH + 1;		# Date the sale is made in DD format
my $SALE_MODEL_YEAR		= $SALE_DAY + 1;		# Vehicles model year
my $SALE_MODEL_NAME		= $SALE_MODEL_YEAR + 1;		# Vechicles model name
#
#	Define and reserve the array for AGENT information
#
my @agents;						# Recall AGENT COUNT = $#agents
my $AGENT_ID		= 0;				# Sales AGENT ID
my $AGENT_DID		= $AGENT_ID + 1;		# Dealer ID for this AGENT
my $AGENT_OID		= $AGENT_DID + 1;		# Owner ID for this AGENT
my $AGENT_FNAME		= $AGENT_OID + 1;		# AGENT's first name
my $AGENT_LNAME		= $AGENT_FNAME + 1;		# AGENT's last name
my $AGENT_FULLNAME	= $AGENT_LNAME + 1;		# AGENT's full name (redundant = last_name, first_name)
my $AGENT_IDCODE	= $AGENT_FULLNAME + 1;		# AGENT ID CODE Ddd-oo-aa
#
# Simple output format for checking the agent data
#
my ($agent, $agent_id, $check );

format AGENT_TEST =
AGENT : @<<<<<<<<<<<<<<<<<<<<< ID: @<<<<<<<<<  CHECK: @<<<<<<<<<<<<
$agent, $agent_id, $check
.

my @dealers;						# Recall DEALER COUNT = $#agents
my $DEALER_ID		= 0;				# Sales DEALER ID
my $DEALER_NAME		= $DEALER_ID + 1;		# FULL NAME for this DEALER
my $DEALER_ADDRESS	= $DEALER_NAME + 1;		# Address for this DEALER
my $DEALER_CITY		= $DEALER_ADDRESS + 1;		# City for this DEALER
my $DEALER_STATE	= $DEALER_CITY+ 1;		# STATE for this DEALER
my $DEALER_OID		= $DEALER_STATE + 1;		# Owner ID for this dealer
my $DEALER_MS		= $DEALER_OID + 1;		# Market size for this dealer
my $DEALER_AID		= $DEALER_MS + 1;		# Used internally for checking data entry
#
# Simple output format for checking the agent data
#

my ( $dealer, $dealer_id, $owner_id ); 

format DEALER_TEST =
DEALER : @<<<<<<<<<<<<<<<<<<<<< ID: @<<< OID: @<<<  CHECK: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$dealer, $dealer_id, $owner_id, $check
.

my @owners;
my $OWNER_ID = 0;					# Owner ID
my $OWNER_FNAME = $OWNER_ID + 1;			# Owner's first name
my $OWNER_LNAME = $OWNER_FNAME + 1;			# Owner's last name
my $OWNER_FULLNAME = $OWNER_LNAME + 1;			# Owner's full name - redundent
my $OWNER_AID	   = $OWNER_FULLNAME + 1;		# Used internally for checking data entry

my ( $first_name, $last_name );
format OWNER_TEST =
OWNER ID: @<< Name: @<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<
$owner_id, $first_name, $last_name
.

my $TEMP_VIN = 0;
my $TEMP_MODEL = $TEMP_VIN + 1;
my $TEMP_MYEAR = $TEMP_MODEL + 1;
my $TEMP_PRICE = $TEMP_MYEAR + 1;
my $TEMP_ORIGP = $TEMP_PRICE + 1;
my $TEMP_ALNAME = $TEMP_ORIGP + 1;
my $TEMP_AFNAME = $TEMP_ALNAME + 1;
my $TEMP_WDAY   = $TEMP_AFNAME + 1;
my $TEMP_MONTH  = $TEMP_WDAY + 1;
my $TEMP_DAY    = $TEMP_MONTH + 1;
my $TEMP_YEAR   = $TEMP_DAY + 1;
my $TEMP_AID    = $TEMP_YEAR + 1;


my @used_discount = (0.18, 0.28, 0.38, 0.48, 0.56, 0.62, 0.67, 0.72, 0.75, 0.775, 0.80, 0.825, 0.850, 0.875, 0.090, 0.91, 0.92, 0.93, 0.94, 0.95 );
print "USED DISCOUNTS $#used_discount \n";

my @temp;
my $outdir = "s";
print "Done with definitions!! \n";
print "Welcome the SHS sales data importer\n";
print "Please enter the year for this database table ($YEAR_MIN to $YEAR_MAX) :\n";
my $ym = $YEAR_MIN-1;
my $year = $ym;
$year = <>;
chomp($year);
if( ( $year > $YEAR_MAX ) || ( $year < $YEAR_MIN ) ) {
    print "Selected year $year is outside the allowed range\n";
	exit;
}
print "Selected,  $year \n";

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
##### NOTE: CHANGING to GETTING DATA FROM agents.txt to deal with perl version problem
#
my $agentsfile = "SALESDATA/agents.txt";
open( my $AF, "<", $agentsfile ) or die "can't open $agentsfile $?";
my @dlist;
my @olist;
my $agent_count=0;
while ( my $line = <$AF> ) {
	chomp $line;
	my @agentdata = split "\t+", $line;
	my ( $lname, $fname ) = split /\s*,\s*/, $agentdata[1];
	if ( $DEBUG == 1 ) {
		print "$agent_count $#agentdata ";
	}
#
# Repackage the agent data
#
	$agents[$agent_count][$AGENT_ID] 	= $agentdata[7];
	$agents[$agent_count][$AGENT_DID] 	= $agentdata[6];
	$agents[$agent_count][$AGENT_OID] 	= $agentdata[8];
	$agents[$agent_count][$AGENT_FNAME] 	= $fname;
	$agents[$agent_count][$AGENT_LNAME] 	= $lname;
	$agents[$agent_count][$AGENT_FULLNAME] 	= $agentdata[1];
	$agents[$agent_count][$AGENT_IDCODE] 	= $agentdata[9];
	my $aid = $agent_count;
	if ( $DEBUG == 1 ) {
		print "ACOUNT = $agent_count AID = $agents[$aid][$AGENT_ID] DID = $agents[$aid][$AGENT_DID] OID = $agents[$aid][$AGENT_OID] Name = $agents[$aid][$AGENT_FULLNAME]";
		print " IDCODE = $agents[$aid][$AGENT_IDCODE] \n";
	}
#
#	Repackage the dealship data
#
	my ( $dstreet, $dcity, $dstate ) 	= split /\s*,\s*/, $agentdata[4];
	$dlist[$agent_count][$DEALER_ID]  	= $agentdata[6];	# Dealership ID
	$dlist[$agent_count][$DEALER_NAME]  	= $agentdata[2];	# Dealership Name
	$dlist[$agent_count][$DEALER_OID]  	= $agentdata[8];	# Owner ID
	$dlist[$agent_count][$DEALER_ADDRESS]  	= $dstreet;		# Dealership Street Address
	$dlist[$agent_count][$DEALER_CITY]  	= $dcity;		# Dealership City
	$dlist[$agent_count][$DEALER_STATE]  	= $dstate;		# Dealership State
	$dlist[$agent_count][$DEALER_MS]  	= $agentdata[5];	# Dealership Market Size
	$dlist[$agent_count][$DEALER_AID]	= $agentdata[9];	# Agent id for this entry - for internal consistency
#
#	Repackage the owner data
#
	my ( $oln, $ofn ) = split /\s*,\s*/, $agentdata[3];
	$olist[$agent_count][$OWNER_ID]  	= $agentdata[8];	# Owner ID
	$olist[$agent_count][$OWNER_FNAME]  	= $ofn;			# Owner First Name
	$olist[$agent_count][$OWNER_LNAME]  	= $oln;			# Owner Last Name	
	$olist[$agent_count][$OWNER_FULLNAME]	= $agentdata[3];	# Owner Full Name
	$olist[$agent_count][$OWNER_AID]	= $agentdata[9];	# Agent identifier for this entry
	$agent_count++;
}
if ( $DEBUG == 1 ) {
	for ( my $i = 0; $i < $agent_count; $i++ ) {
		print "agent $i AID = $agents[$i][$AGENT_ID] FNAME = $agents[$i][$AGENT_FNAME] LNAME = $agents[$i][$AGENT_LNAME] FULL = $agents[$i][$AGENT_FULLNAME] ";
		print "IDCODE = $agents[$i][$AGENT_IDCODE] DID = $agents[$i][$AGENT_DID] OID = $agents[$i][$AGENT_OID]\n";
	}
	for ( my $i = 0; $i < $agent_count; $i++ ) {
		print "dealer $i DID = $dlist[$i][$DEALER_ID] DNAME = $dlist[$i][$DEALER_NAME] OID = $dlist[$i][$DEALER_OID] AID = $dlist[$i][$DEALER_AID] ";
		print "DADD = $dlist[$i][$DEALER_ADDRESS] CITY = $dlist[$i][$DEALER_CITY] STATE = $dlist[$i][$DEALER_STATE] DMS = $dlist[$i][$DEALER_MS]\n";
	}
	for ( my $i = 0; $i < $agent_count; $i++ ) {
		print "owner $i OID = $olist[$i][$OWNER_ID] FNAME = $olist[$i][$OWNER_FNAME] LNAME = $olist[$i][$OWNER_LNAME] FULLNAME = $olist[$i][$OWNER_FULLNAME] ";
		print "AID = $olist[$OWNER_AID]\n";
	}
}
#	TEST OUTPUT TO MAKE SURE WE GOT DATA
#
$~ = "AGENT_TEST";
for my $i (0..$#agents) {
	$agent = $agents[$i][$AGENT_FULLNAME];
	$agent_id = $agents[$i][$AGENT_ID];
	$check    = $i . "-" . $agents[$i][$AGENT_DID] . "-" . $agents[$i][$AGENT_OID];
write;
}
#
#	Need to transfer data to dealer array from dlist - includes making sure we have only one entry for each dealer
#
my $dcount=0;
for ( my $k = 0; $k<=$DEALER_AID; $k++ ) {
	$dealers[0][$k] = $dlist[0][$k];
}
$dcount++;
for ( my $i = 1; $i < $agent_count; $i++ ) {
	my $found = 0;
	for ( my $j = 0; $j < $dcount; $j++ ) {
		if ( $dealers[$j][$DEALER_ID] == $dlist[$i][$DEALER_ID] ) {
			$found++;
		}
	}
	if ( $found == 0 ) {
		for ( my $k = 0; $k<=$DEALER_AID; $k++ ) {
			$dealers[$dcount][$k] = $dlist[$i][$k];
		}
		$dcount++;
	}
}

#
# TEST OUTPUT TO MAKE SURE WE GOT DATA
#

$~ = "DEALER_TEST";
for my $i (0..$#dealers ) {
	$dealer = $dealers[$i][$DEALER_NAME];
	$dealer_id = $dealers[$i][$DEALER_ID];
	$owner_id  = $dealers[$i][$DEALER_OID];
	my $ip = $i+1;
	$check    = $ip . "-" . $dealers[$i][$DEALER_OID] . "\t" . $dealers[$i][$DEALER_ADDRESS] . ", " . $dealers[$i][$DEALER_CITY] . ", " . $dealers[$i][$DEALER_STATE] ;
write;
}

#
#	Need to transfer data to owners array from olist - includes making sure we have only one entry for each owner
#
my $ocount=0;
for ( my $k = 0; $k<=$OWNER_AID; $k++ ) {
	$owners[0][$k] = $olist[0][$k];
}
$ocount++;
for ( my $i = 1; $i < $agent_count; $i++ ) {
	my $found = 0;
	for ( my $j = 0; $j < $ocount; $j++ ) {
		if ( $owners[$j][$OWNER_ID] == $olist[$i][$OWNER_ID] ) {
			$found++;
		}
	}
	if ( $found == 0 ) {
		for ( my $k = 0; $k<=$OWNER_AID; $k++ ) {
			$owners[$ocount][$k] = $olist[$i][$k];
		}
		$ocount++;
	}
}

##
## TEST OUTPUT TO MAKE SURE WE GOT DATA
##
$~ = "OWNER_TEST";
for my $i (0..$#owners ) {
	$owner_id = $owners[$i][$OWNER_ID];
	$first_name = $owners[$i][$OWNER_FNAME];
	$last_name = $owners[$i][$OWNER_LNAME];
write;
}
#
#	WE NOW HAVE ALL TABLE DATA IN ARRAYS AND WE WANT TO INSERT THE SALES DATA
#	IT WILL GO INTO TABLES 
#
print "starting output - $year\n";
$outdir = "$outdir"."$year";
if( !-e "$outdir" ) {
	mkdir("$outdir", 0700) || die "Can't create directory $outdir \n";
}
chdir("./$outdir") || die "Can't change to directory $outdir \n";
#
#	Open mysql batch file;
#
my $sfile = "sales"."$year".".sql";
open( BATCH, ">", $sfile ) or die "cannot open $sfile:  $!";
#
#	Create MYSQL input file for creating table
#
my $salesdir = "$datapath/y"."$year";
print "SALESDIR - $salesdir-\n";
if( -e "$salesdir" ) {
	print "Accessing $salesdir \n";
	opendir ( SALESDIR, $salesdir ) or die "cannot open $salesdir: $!";
	my @weekly_dirs = readdir SALESDIR;
	@weekly_dirs = sort @weekly_dirs;
	shift @weekly_dirs;	# get rid of . from directory list
	shift @weekly_dirs;	# get rid of .. from directory list
	print @weekly_dirs . "\n";
	closedir SALESDIR;
	print BATCH "USE $database;\n";
	print BATCH "DROP TABLE IF EXISTS sales_$year;\n";

	for my $i (0..$#weekly_dirs ) {
		print "Processing $weekly_dirs[$i]\n";
		my $this_week_dir = $salesdir . "/" . $weekly_dirs[$i];
		opendir ( SALESDIR, $this_week_dir ) or die "cannot open $this_week_dir: $!";
		my @files = readdir SALESDIR;
		@files = sort @files;
		shift @files;	# get rid of . from directory list
		shift @files;	# get rid of .. from directory list
		closedir SALESDIR;
	
#
#	Create MYSQL file for creating table
#
		my $sql_cmd = "sales"."$weekly_dirs[$i].sql";
		open( TABLE, ">", "$sql_cmd") or die "Can't open file $sql_cmd file: $!";

		print TABLE "USE $database;\n";
		print TABLE "CREATE TABLE IF NOT EXISTS sales_$year( sales_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, dealer_id INT, agent_id VARCHAR(9), owner_id INT, sales_type ENUM('new','used'), vin VARCHAR(25), ";
		print TABLE " price_sold FLOAT, price_list FLOAT, dealer_cost FLOAT, sales_year INT, sales_month VARCHAR(3), sales_day TINYINT UNSIGNED,";
		print TABLE " model_year INT, model_name VARCHAR(15) );\n";
		
		print BATCH "source ./$sql_cmd;\n";
		
		for my $k (0..$#files) {
			my $fin = "$salesdir"."/$weekly_dirs[$i]/$files[$k]";
			open (DATA, "<", $fin ) or die "cannot open $fin $!";
			my $dline  = <DATA>; chomp $dline ; print "$dline\n";
			my $dadd1  = <DATA>; chomp $dadd1 ; # print "$dadd1\n";
			my $dadd2  = <DATA>; chomp $dadd2 ; # print "$dadd2\n";
			my $didin  = <DATA>; chomp $didin ; print "$didin\n";
			my $downer = <DATA>; chomp $downer; # print "$downer\n";
			my $ddate  = <DATA>; chomp $ddate ; print "$ddate\n";
			my $dtype  = <DATA>; chomp $dtype ; # print "$dtype\n";
			if ( $dtype =~ /New/ ) {
				$dtype = "new";
			}
			my $djunk  = <DATA>;	# Blank line
			$djunk     = <DATA>;	# line of titles
			$djunk 	   = <DATA>;	# line of ='s
			while( my $datain = <DATA> ) {
				chomp $datain;
				if( $datain =~ /J/ ) {				
# print ">> $datain\n";
					$datain =~ s/,//g;
					$datain =~ s/\s+/:/g;
#print "$dtype $datain \n";
					@temp = split(/:+/, $datain);
					shift @temp;
					(my $TDID, my $TOID, my $TLSID ) = split(/-/, $temp[$TEMP_AID]);
					$TDID =~ s/D//;
# print "$#temp 0: $temp[0]  1:$temp[1] 2:$temp[2] 3: $temp[3] 11: $temp[11] \n";
					$sales[$SALE_ID] 	  = "UNKNOWN";
					$sales[$SALE_TYPE]        = $dtype;
					$sales[$SALE_DID]         = $TDID;
					$sales[$SALE_OID]         = $TOID;
					$sales[$SALE_AGENT]       = $temp[$TEMP_AID];
					$sales[$SALE_VIN]         = $temp[$TEMP_VIN];
					$sales[$SALE_PRICE_SOLD]  = $temp[$TEMP_PRICE];
					$sales[$SALE_PRICE_LIST]  = $temp[$TEMP_ORIGP];
					my $cost;
					if( $sales[$SALE_TYPE] eq "new" ){
						$cost = int(($sales[$SALE_PRICE_LIST] - 400)/(1.30));
					} elsif ( $sales[$SALE_TYPE] eq "used" ) {
						my $age  = $temp[$TEMP_YEAR] - $temp[$TEMP_MYEAR];
						$cost = int(($sales[$SALE_PRICE_LIST]*(1-$used_discount[$age])+100+rand(200)));
					} else {
						$cost = 7;
					}
					$sales[$SALE_DEALER_COST] 	= $cost;
					$sales[$SALE_YEAR]        	= $temp[$TEMP_YEAR];
					$sales[$SALE_MONTH]       	= $temp[$TEMP_MONTH];
					$sales[$SALE_DAY]         	= $temp[$TEMP_DAY];
					$sales[$SALE_MODEL_YEAR]  	= $temp[$TEMP_MYEAR];
					$sales[$SALE_MODEL_NAME]  	= $temp[$TEMP_MODEL];
## print " @sales\n";
					print TABLE "INSERT INTO sales_$year( dealer_id, agent_id, owner_id, sales_type, vin,";
					print TABLE " price_sold, price_list, dealer_cost, sales_year, sales_month, sales_day, ";
					print TABLE " model_year, model_name )" ;
					print TABLE " values( '$sales[$SALE_DID]', '$sales[$SALE_AGENT]', '$sales[$SALE_OID]',";
					print TABLE " '$sales[$SALE_TYPE]', '$sales[$SALE_VIN]', '$sales[$SALE_PRICE_SOLD]', '$sales[$SALE_PRICE_LIST]', '$sales[$SALE_DEALER_COST]',";
					print TABLE " '$sales[$SALE_YEAR]', '$sales[$SALE_MONTH]', '$sales[$SALE_DAY]', '$sales[$SALE_MODEL_YEAR]', '$sales[$SALE_MODEL_NAME]' );\n";

				}
				if( $datain =~ /Used/ ) {
					$djunk  = <DATA>;	# Blank line
					$djunk  = <DATA>;	# line of titles
					$djunk 	= <DATA>;	# line of ='s
					$dtype = "used";				
				}
			}
			print "\n";
			close(DATA);
			$k++;
		}
		$i++;
		close( TABLE ) or die "Can't close $sql_cmd: $!";
	}
} else { print "cant find directory\n"; }
close(BATCH);


