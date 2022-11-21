#!/usr/bin/perl
my $yo = 2008;
my $yn = 2016;
my $yc = 8;

my @files = <salesweek*>;
foreach my $file (@files) {
	my $nfile = $file;
	$nfile =~ s/salesweek/newsw/;
	open (my $OD, "<", "$file" ) or die "couldn't open $file $?";
	open (my $ND, ">", "$nfile" ) or die "couldn't open $nfile $?";
	my $header  = <$OD>;
	chomp $header;
	print $ND "$header\n";
	while ( my $line = <$OD> ) {
		chomp $line;
		my @values = split( / /, $line );
		my $year = "$values[30]";
		$year =~ s/'//g;
		$year =~ s/,//g;
		$values[30] = "'2016',";
		if ( "$values[22]" eq "'new'," ) {
			$values[27] = "'2016',";
		} else {
			$year = $year + 1;
			$values[27] = "'$year',";
		}
#		print "$#values $file - $values[22] - $year - $values[27] - $values[30] \n";
		for (my $i=0;$i<=$#values;$i++) {
			print $ND "$values[$i] ";
		}
		print $ND "\n";
	}
	close ( $OD );
	close ( $ND );
}
