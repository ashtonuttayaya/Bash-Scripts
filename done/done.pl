#!/usr/bin/perl -w
use strict;
BEGIN { push @INC, './done' }
use Net::Domain qw(hostname hostfqdn hostdomain);
use ANS;
my $DEBUG = 0;
my $debug_code = "DEBUG done.pl";
my $fname = $ARGV[0];
my $lname = $ARGV[1];
my $assignment = $ARGV[2];
my $dir = `pwd`;
chomp($dir);
my $assignment_type = "h";
if ( $assignment =~ /a/ ) {
	$assignment_type = "a"; 
} elsif ( $assignment =~ /e/ ) {
	$assignment_type = "e"; 
} else { 
	$assignment_type = "h"; 
}

my $target = "$dir" . "/$assignment";
my $config = $target . "/$assignment" . "config";
my $hdir   = "$target/.data";
my @scores;			# array for holding score information
my @results;			# array for holding info on user's submission files
my @best;			# array for holding info on all submissions files
my @missing;			# array for holding missing files
my $tfound=0;			# tracks found files
my $tmissing = 0;		# tracks missing files
if ( $DEBUG > 0 ) { print "$debug_code : $target\n"; }
my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
my @days   = qw(Sunday Monday Tueday Wednesday Thursday Friday Saturday Sunday);

#
#	Read and store the configuration data
#
open( my $CNF, "<", $config ) or die "Unable to read $config $!";
my @configs;
my @qtypes;

while( my $line = <$CNF> ) {
	chomp( $line );
        if( ! ( $line =~ /^#/ ) ) {                             # Allow for comments in the config file
                my @line_array = split( /\s+/, $line );
		if ( $DEBUG > 0 ) { print "@line_array $#line_array\n"; }
                if( $line_array[1] eq "submit" ) {
                        push( @configs, \@line_array );
                }
		if ( $line_array[1] eq "type" ) {
			push ( @qtypes, $line_array[2] );
		}
        }
}
close( $CNF );
if( $DEBUG > 0 ) {
	for my $ic (0..$#configs) {
		print "$debug_code $ic $#{$configs[$ic]} qtypes = $qtypes[$ic]\n";
		for my $icc (0..$#{$configs[$ic]}) {
			print "$debug_code $ic $icc $configs[$ic][$icc]\n";
		}
	}
}
#
#	Create the answer file header.
#
my $file = $assignment . ".txt";
$file =~ s/h/hwk/;
$file =~ s/e/exm/;
$file =~ s/a/lab/;
my $answerfile = "$target/" . "$file";
open( my $ANSF, ">", $answerfile ) or die "Unable to open $answerfile $!";
#
#	Create and print header information
#
my $anum = $assignment;
$anum =~ s/^[ahe]//;
$anum =~ s/^0//;
my $title="";
if ( $assignment =~ /^h/ ) {
	$title = "Homework $anum: submission file $file";
} elsif ( $assignment =~ /^e/ ) {
	$title = "Exam $anum: submission file $file";
} elsif ( $assignment =~ /^a/ ) {
	$title = "Activity $anum: submission file $file";
}
my $user = getpwuid( $< );
my $host = hostname();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year = $year + 1900;
my $date = "$days[$wday], $months[$mon] $mday, $year";
my $time = "$hour:$min";
print $ANSF "$title\n\n";
print       "$title\n\n";
print $ANSF "    Name:    $fname $lname\n";
print $ANSF "    User:    $user\n";
print $ANSF "    Host:    $host\n";
print $ANSF "    Date:    $date\n";
print $ANSF "    Time:    $time\n";
#
#	Generate unique assignment submission code.
#
my $secret = $fname . "-" . $months[$mon] . "@" . $assignment . "}" . $lname . "*" . $time . "!" . $user . "%" . $year . "{" . $host . "#" . $mday;
my @rcode = ( "a".."z", "0".."9", "A".."Z" );
my $coded="";
my $slen = length( $secret );
for ( my $si = $slen-1; $si >= 0; $si-- ) {
	my $sr = rand( ($#rcode-1) );
	my $ss = substr $secret, $si, 1;
	my $st = $rcode[$sr];
	$coded = $coded . $st . $ss; 
} 
	print $ANSF "    USID:    $slen$coded\n";
print $ANSF "\n";
#
#	Loop over the questions
#
print "  Done checking questions: ";

foreach my $ic (0..$#configs) {

	my $question = "$target/"."$configs[$ic][0]";
	my $qtype    = "";				# used to hold the question type (tf, sa, sc, ac, etc.)
	my $num  = $configs[$ic][0];
	my $qn   = $num;
	my $qnum = $num;
	$num =~ s/^q//;
	$num =~ s/^0//;
	$qnum =~ s/^q//;
	my @files;

	if ( $DEBUG > 0 ) { print "$debug_code: $qn $num $qnum $question \n";}
#
#	Create the answer file and the backup file using the template and the answers in solutionXX.txt
#
	my $qdir      = $question;					# Question Directory .../class/hXX/QYY (or .../class/eXX/QYY or .../class/aXX/QYY)
	my $atxt      = "$qdir/" . "a" . "$qnum" . ".txt";		# (user) aXX.txt
	my $check     = "$qdir/" . "check" . "$qnum" . ".txt";		# (user) checkXX.txt (used for checking results of sc or ac questions)
	my $qscript   = "$qdir/" . "q" . "$qnum" . ".sh";		# (user) qXX.sh script required by assignment
	my $script    = "$qdir/" . "script"  . "$qnum" . ".sh";
	my $checker   = "$qdir/" . "check"   . "$qnum" . ".sh";		# provided to the user for all ac or sc type questions
	my $hsolution = "$hdir/.c" . "$qnum" . ".txt";			# (key) should match user's aXX.txt
	my $hcheck    = "$hdir/.s" . "$qnum" . ".txt";			# (key) should match user's checkXX.txt
	my $hchecker  = "$hdir/.c" . "$qnum" . ".sh";			# (key) checkXX.sh file
	my $hscript   = "$hdir/.s" . "$qnum" . ".sh";			# (key) scriptXX.sh (in script questions this is used by checkXX.sh to create key for checkXX.txt )
	my $tmp_check = "";						# used if user didn't create a checkXX.txt file
        if ( -e $checker ) {
                if ( -e $hchecker ) { unlink $hchecker }
                system( "cd $hdir; ln -s $checker $hchecker" );
        }
	print $ANSF "BEGIN QUESTION $num\n";
	print $ANSF "    Checking for required files\n";
	$best[$ic][0] = 0;		# number of files expected for this question
	$best[$ic][1] = 0;		# number of answers expected in the a01.txt file
	$best[$ic][2] = 0;		# 1 if $hchecker file is present, 0 otherwise
	$best[$ic][3] = 0;		# 1 if $hscript file is present, 0 otherwise
	$results[$ic][0] = 0;
	$results[$ic][1] = 0;
	$results[$ic][2] = 0;
	$results[$ic][3] = 0;
#
#	Determine problem type
#
	$qtype = $qtypes[$ic];					# get qtype for this problem
	if ( $DEBUG > 0 ) { print "DEBUG: qtype = $qtypes[$ic] \n"; }
#	if( -e $hchecker ) {
#		if( -e $hscript ) {
#			$qtype = "sc";
#		} else {
#			$qtype = "ac";
#		}
#	}

	if( -e $hsolution ) {				# check for aXX.txt
		$best[$ic][0]++;
		$best[$ic][1]++;
		if( -e $atxt ) {
			$results[$ic][0]++;
			$results[$ic][1]++;
		}
		my $nf = "a$qnum" . ".txt";
		push @files, $nf;
	}
	if( -e $hcheck ) {				# check for checkXX.txt
		$best[$ic][0]++;
		$best[$ic][2]++;
		my $nf = "check$qnum" . ".txt";
		push @files, $nf;
		if( -e $check ) {
			$results[$ic][0]++;
			$results[$ic][2]++;
		} else {				# check does not exits - we create .checkXX.txt to use later
			if( $qtype eq "ac" || $qtype eq "sc" ) {
				$tmp_check = $check;
				$tmp_check =~ s/\/check/\/.check/;
				system ( "$hchecker >> $tmp_check");
				$results[$ic][0]++;
				$results[$ic][2]++;
				if( $DEBUG > 0 ) {
					my $wc = `cat $tmp_check | wc -l `;
					print "$tmp_check line count = $wc \n"; 
				}
			}
		}
	}
	if( -e $hscript && "$qtype" eq "sc" ) {				# check for qXX.sh
		if ( $DEBUG > 0 ) { print "storing qXX.sh in output file list\n"; }
		$best[$ic][0]++;
		$best[$ic][3]++;
		my $nf = "q$qnum" . ".sh";
		push @files, $nf;
		if( -e $qscript ) {
			$results[$ic][0]++;
			$results[$ic][3]++;
		}
	}
	if ( $DEBUG > 1 ) { print $ANSF "$debug_code: ic = $ic total files = $best[$ic][0] aXX.txt = $best[$ic][1] cXX.txt = $best[$ic][2] qXX.sh = $best[$ic][3]\n"; }
	if ( $DEBUG > 1 ) { print $ANSF "$debug_code: ic = $ic found files = $results[$ic][0] aXX.txt = $results[$ic][1] cXX.txt = $results[$ic][2] qXX.sh = $results[$ic][3]\n"; }
	if( $#{$configs[$ic]} >= 2 ) {
		for my $n (2 .. $#{$configs[$ic]} ) {
			push @files, $configs[$ic][$n];
		}
	}
	if ( $DEBUG > 1 ) { print $ANSF "$debug_code: ic = $ic total files = $best[$ic][0] aXX.txt = $best[$ic][1] cXX.txt = $best[$ic][2] qXX.sh = $best[$ic][3]\n"; }

	for my $n (0..$#files) {
		my $ofile = "$question/" . "$files[$n]";
		if( $files[$n] =~ /check/ && $tmp_check =~ /check/ ) {			# did we have to create a temporary copy of checkXX.txt
			$ofile = $tmp_check;						# if so use it rather than skipping checkXX.txt
		}
		if ( $DEBUG > 0 ) { print $ANSF " Debug: $files[$n] $qtype q$qnum.sh \n"; }
		if( -e $ofile && ! ( $files[$n] =~ /q$qnum.sh/ && $qtype eq "ac" ) ) {
		if ( $DEBUG > 0 ) { print $ANSF " Debug: $files[$n] $qtype q$qnum.sh \n"; }
			print $ANSF "\n        Start output of $files[$n]\n";
			open( my $OFILE, "<", $ofile ) or die "Unable to read $ofile $!";
			while( my $l = <$OFILE> ) {
				chomp($l);
				print $ANSF "            $l\n";
			}
			print $ANSF "\n        End output of $files[$n]\n";
			close($OFILE);
			print $ANSF "\n";
			$tfound++;
		} else {
			print $ANSF "\n        File $files[$n] IS MISSING\n\n";
			my @mfile = ( "Question $num", $files[$n] );
			push @missing, \@mfile;
			$tmissing++;
		}
		if( $files[$n] =~ /check/ && $tmp_check =~ /check/ ) {			# remove temporary copy of checkXX.txt after copy
			if( -e $tmp_check ) { 			
				system( "rm $tmp_check" ); 
			}
		}
	}
	$scores[$ic][0] = $results[$ic][0];
	$scores[$ic][1] = $best[$ic][0];
	if( $best[$ic][0] > $results[$ic][0] ) {
		my $diff = $best[$ic][0] - $results[$ic][0];
		print $ANSF "    $diff files missing for question $num.\n";
	} else {
		print $ANSF "    All files found for question $num.\n";
	}
#
#	Next step is to compare the files that should be the same
#
#	Returns maximum score, results of running checkXX.sh and scores on parts in aXX.txt
#
	if( $DEBUG > 0 ) { print "$debug_code: $question, $qnum, $num, $qtype - call check\n"; }
	my ( $cscore, $cscmax, @ascore ) =  ANS::check( $question, $qnum, $num, $qtype );
	my $asc = 0;
	for my $as ( 0 .. $#ascore ) {
		$asc = $asc+$ascore[$as];
	}
	$scores[$ic][2] = $cscore;	# cscore from running checkXX.sh (when needed)
	$scores[$ic][3] = $cscmax;	# ultimately 1 or 0 depending on if cscore is expected or not
	$scores[$ic][4] = $asc;		# score for aXX.txt
	$scores[$ic][5] = $#ascore+1;	# maximum possible score for aXX.txt

#
#	In the end an $fscore will be determined based on number of missing files
#
	print $ANSF "END QUESTION $num\n\n";
	print "  $num";		# used to tell user where we are in the process
}				# end loop over questions
print "\n";			# used to tell user where we are in process
#
#	Create the answer file tail
#
print $ANSF "    Begin summary of file submissions\n";
print       "    Begin summary of file submissions\n";

my $total = $tfound + $tmissing;
print $ANSF "        Files needed  = $total\n";
print $ANSF "        Files found   = $tfound\n";
print $ANSF "        Files missing = $tmissing\n";
print       "        Files needed  = $total\n";
print       "        Files found   = $tfound\n";
print       "        Files missing = $tmissing\n";
if( $tmissing > 0 ) {
	for my $n (0..$#missing) {
		print $ANSF "        $missing[$n][0] $missing[$n][1] not found\n";
	}
}
print $ANSF "    End summary of file submissions\n\n";
print       "    End summary of file submissions\n\n";
my $ttscore = 0;	# user score
my $mtscore = 0;	# maximum score
if( $assignment_type eq "h" ) {
	print $ANSF "    Begin summary of question checks\n";
	print       "    Begin summary of question checks\n";
	for my $sci ( 0 .. $#scores ) {
		my $tscore = 0;
		my $mscore = 0;
		my $encourage = "";
		my $qnn = $sci + 1;
		my $qnum = "";
		if( $qnn < 10 ) { 
			$qnum = $qnum . "0$qnn";
		} else {
			$qnum = $qnum . "$qnn";
		}
		$tscore = $tscore + $scores[$sci][0];
		$mscore = $mscore + $scores[$sci][1];

		if( $scores[$sci][3] > 0 ) {
			$tscore = $tscore + $scores[$sci][2];
			$mscore = $mscore + $scores[$sci][3];
		}
		$tscore = $tscore + $scores[$sci][4];
		$mscore = $mscore + $scores[$sci][5];
		if( $tscore == $mscore ) {
			$encourage = "Correct!        ";
			$mtscore++;
			$ttscore++;
		} else {
			$encourage = "Needs more work.";
			$mtscore++;
		}
		print $ANSF "        Question $qnn: $encourage a$qnum.txt - $scores[$sci][4] of $scores[$sci][5] correct,";
		print       "        Question $qnn: $encourage a$qnum.txt - $scores[$sci][4] of $scores[$sci][5] correct,";
		if( $scores[$sci][3] > 0 ) {
			if( $scores[$sci][2] == $scores[$sci][3] ) {
				print $ANSF " check$qnum.sh gets correct answer,";
				print       " check$qnum.sh gets correct answer,";
			} else {
				print $ANSF " check$qnum.sh gets incorrect answer,";
				print       " check$qnum.sh gets incorrect answer,";

			}
		}
		if( $scores[$sci][0] == $scores[$sci][1] ) {
			print $ANSF " all files present.\n";
			print       " all files present.\n";
		} else {
			my $nm = $scores[$sci][1] - $scores[$sci][0];
			if( $nm == 1 ) {
				print $ANSF " missing $nm file.\n";
				print       " missing $nm file.\n";
			} else {
				print $ANSF " missing $nm files.\n";
				print       " missing $nm files.\n";
			}
		}
	}
	if( $ttscore == $mtscore ) {
			print $ANSF "    Good job! You got all $mtscore questions right\n";
			print       "    Good job! You got all $mtscore questions right\n";
	} else {
			print $ANSF "    $ttscore out of $mtscore questions correct\n";
			print       "    $ttscore out of $mtscore questions correct\n";
	}

	print $ANSF "    End summary of question checks\n\n";
	print       "    End summary of question checks\n\n";
}
print $ANSF "$title completed\n";
print       "$title created\n";
