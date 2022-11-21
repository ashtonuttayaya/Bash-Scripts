package ANS;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(check);

sub check {
my $qfile = $_[0];
my $qsym  = $_[1];
my $qnum  = $_[2];
my $qtype = $_[3];
my $cscore = 0;			# returns the score on running checkXX.sh (1 = correct, 0=incorrect)
my $cscmax = 0;			# 1 if this is an "ac" or "sc" type problem, 0 otherwise
my @ascore;			# returns the scores on the parts of aXX.txt as an array (1=correct, 0=incorrect)
my $user = $qfile . "/a$qsym.txt";
my ($hfile, $jend ) = split( /\/q/, $qfile );
my $key  = $hfile . "/.data/.c$qsym.txt";
my $DEBUG = 0;
if( $DEBUG > 0 )  { print "DEBUG ANS: Calling compare_txt: $qsym, $qnum, $qtype: $user   $key\n"; }

@ascore = compare_txt( $qfile, $qsym, $qnum, $qtype, $user, $key );

if( $qtype eq "sc" || $qtype eq "ac" ) {
	$cscmax = 1;
	$key = $hfile . "/.data/.s$qsym.txt";
	$user = $qfile . "/check$qsym.txt";
	$cscore = compare_sh( $qfile, $qsym, $qnum, $qtype, $user, $key );
}

return ($cscore, $cscmax, @ascore );
}

#
#	compare_txt used to check the aXX.txt files.
#
sub compare_txt {
my $qfile = $_[0];
my $qsym  = $_[1];
my $qnum  = $_[2];
my $qtype = $_[3];
my $user  = $_[4];
my $key   = $_[5];
my @parts = ( "A.", "B.", "C.", "D.", "E.", "F.", "G.", "H.", "I.", "J.", "K.", "L.", "M.", "N.", "O.", "P.", "Q.", "R.", "S.", "T.", "U." );
open( my $KEY, "<", $key ) or die "Question $qnum: Unable to read standard key file $!";
open( my $USER, "<", $user ) or die "Unable to read $user $!";
my @kanswers;
my @uanswers;
my @ufile;
my @atype = "sa";
my $DEBUG = 0;
while( my $line = <$KEY> ) {
	chomp($line);
	if( $line =~ /KEY$/ ) {
		if( $line =~ /True or False/ ){
			$atype = "tf";
		} elsif ( $line =~ /Computer Activity/ ) {
			$atype = "ac";
		} elsif ( $line =~ /Short Answers/ ) {
			$atype = "sa";
		} elsif ( $line =~ /Script Creation/ ) {
			$atype = "sc";
		}
		for my $i (0..$#parts) {
			if( $line =~ /\Q$parts[$i]/ ) {
				push @kanswers, $line;
			}
		}
	}
}
# print "DEBUG ANS: QKEY $qnum $atype $#kanswers\n";
close($KEY);
#
#	First thing we need to do is clean up the user's answers
#	will start by getting non-blank lines between the A. and the
#	END OF QUESTION strings and put them into an array (ufile)
#
while( my $line = <$USER> ) {
	chomp($line);
	$line =~ s/\s+KEY\s+$//;		# remove trailing KEY
	$line =~ s/\s+/ /g;			# remove excess blanks
	$line =~ s/^\s+|\s+$//g;		# Trialing and leading whitespace
	my $found = 0;
	for my $i (0..$#parts) {
		if( $line =~ /^\Q$parts[$i]/ ) {
			$line=~ s/^\Q$parts[$i]/$parts[$i] /;		# make sure there is at least one blank after leading letter and period.
			$found++;
			push @ufile, $line;
			while( my $l2 = <$USER> ) {
				chomp($l2);
				$l2 =~ s/\s+/ /g;			# remove excess blanks
				$l2 =~ s/^\s+|\s+$//g;			# Trialing and leading whitespace
				if( (length $l2 ) && ($l2 !~ /^END OF QUESTION/ ) ) {
					push @ufile, $l2;
				}
			}
		}
	}
	if ( $DEBUG > 0 ) { print "DEBUG CLEANED LINE =$line\n"; }

#	push @uanswers, $line;
}
close($USER);
# DEBUG CODE
#	print "DEBUG ANS: QUSER $qnum $#ufile\n";
#	for my $i (0..$#ufile) {
#		print "DEBUG ANS: $ufile[$i]\n";
#	}
# DEBUG CODE
#
#	Next step in the clean up is to merge answers spanning multiple lines onto one line
#
my @aspan;
for my $i (0..$#kanswers) {
	for my $j (0..$#ufile) {
		if( $ufile[$j] =~ /\Q$parts[$i]/ ) {
			$aspan[$i][0] = $j;
			if( $i > 0 ) { 
				my $k = $i-1;
				$aspan[$k][1] = $j-1;
#				print "DEBUG ANS: $i, $k, $aspan[$k][0] $aspan[$k][1] match at $j\n";
			}
		}
	}
}
$aspan[$#kanswers][1] = $#ufile;			# where last answer ends;
if( $DEBUG > 0 ) {
 for my $i (0..$#kanswers) {
	print "DEBUG ANS: index = $i start = $aspan[$i][0] end = $aspan[$i][1]\n";
 }
}
for my $i (0..$#kanswers) {
	$uanswers[$i]="";
	for my $j ($aspan[$i][0]..$aspan[$i][1]) {
		$uanswers[$i] = $uanswers[$i] . " $ufile[$j]";
	}
	$uanswers[$i] =~ s/\s+/ /g;			# remove excess blanks
	$uanswers[$i] =~ s/^\s+|\s+$//g;		# Trialing and leading whitespace
}
# DEBUG CODE
if( $DEBUG > 0 ) {
	print "DEBUG ANS: QUSER $qnum $#uanswers\n";
	for my $i2 (0..$#uanswers) {
		print "DEBUG ANS: $uanswers[$i2]\n";
	}
}
# DEBUG CODE
my @ascores;
for my $i (0..$#kanswers) {
	$kanswers[$i] =~ s/ KEY$//;
	$uanswers[$i] =~ tr/a-z/A-Z/;
	$kanswers[$i] =~ tr/a-z/A-Z/;
	if ( $atype eq "tf" ) {
		if( $uanswers[$i] =~ /TRUE$/ ) {
			$uanswers[$i] =~ s/TRUE$/T/;
		}
		if( $uanswers[$i] =~ /FALSE$/ ) {
			$uanswers[$i] =~ s/FALSE$/F/;
		}
	}

	if( $DEBUG > 0 ) { print "DEBUG ANS compare_txt: $kanswers[$i] $uanswers[$i]\n"; }

	if( $kanswers[$i] eq $uanswers[$i] ) {
		$ascores[$i] = 1;
	} else {
		$ascores[$i] = 0;
	}
}
return @ascores;
}

#
#	Used to check the results of the check script
#
sub compare_sh {
my $qfile = $_[0];
my $qsym  = $_[1];
my $qnum  = $_[2];
my $qtype = $_[3];
my $user  = $_[4];
my $key   = $_[5];
my $DEBUG = 0;
my $cscore = 0;
my $kscript = $key;
$kscript =~ s/\Q.s/.c/;
$kscript =~ s/txt$/sh/;
my $uscript = $user;
$uscript =~ s/txt$/sh/;
my $hide = $user;
$hide =~ s/check/.check/;
if( $DEBUG > 0 ) {
	print "DEBUG ANS compare_sh: looking for files\n";
	if( -e $key )     { print "DEBUG ANS compare_sh: key Found:     $key\n"; }
	if( -e $kscript ) { print "DEBUG ANS compare_sh: kscript Found: $kscript\n"; }
}

if( -e $key && -e $kscript ) {
	system( "$kscript > $hide" );
	my $diff = `diff $hide $key`;
	my ($wc1,$j1) = split( / /, `wc -c $hide`);
	my ($wc2,$j2) = split( / /, `wc -c $key` );
	if( ( $wc1 == $wc2 ) && ( $wc1 > 0 ) && ( "$diff" eq "" ) ) {
		$cscore = 1;
	}
	system( "rm $hide" );
}

return $cscore;
}

1;
