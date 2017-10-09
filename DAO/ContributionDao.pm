package DAO::ContributionDao;

use strict;
use warnings;

require Data::Contribution;
require DAO::ConnectionDao;
require Utilities::Time;

sub addContribution{
	my ($type, $cont_pc, $cont_amount, $salary, $effective_date, $employees_id, $charity_id) = @_;
	
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $query = $connection->prepare('insert into contributions (type,cont_pc,cont_amount,salary,process_date,effective_date,employees_id,charity_id) values (?, ?, ?, ?, ?, ?, ?, ?)');
	
	unless($query){
		die "Error preparing contribution SQL query\n";
	}
	
	my $process_date = Utilities::Time::getCurrentTimestamp();
	
	unless($query->execute($type, $cont_pc, $cont_amount, $salary, $process_date, $effective_date, $employees_id, $charity_id)){
		print "Error executing contribution SQL query\n";
		return 0;
	}
	
	$query->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return 1;
}

sub validateInput{
	my (@values) = @_;
	
	foreach my $value(@values){
		if(! defined($value) || length($value) == 0){
			die "Invalid contribution input\n";
		}
	}
}

sub getAllContributionsForEmployeeIdFromCSV{
	my ($filePath, $employeeId) = @_;
	
	open(INPUT, $filePath) or die "File not found: $filePath\n";
	
	my @headers = split /\s*,\s*/, <INPUT>;	
	my @contributions;
	
	while(my $line = <INPUT>){
		my %hash;
		$line =~ /\S+/ or next;
		chomp $line;
		my @fields = split /\s*,\s*/, $line;
		
		if(scalar(@fields) != scalar(@headers)){
			print "Invalid row: $line";
			next;
		}
		
		if($fields[0] eq $employeeId){
			my $contribution = new Data::Contribution($fields[0], $fields[1], $fields[2], $fields[3], $fields[4],
				 $fields[5], $fields[6], $fields[7], $fields[8],);
			hashAddContribution(\%hash, $contribution);
			push @contributions,\%hash;
		}
	}
	
	close INPUT;
	return @contributions;
}

sub hashAddContribution{
	my ($contributions, $contribution) = @_;
	my $approvedBy = Data::Contribution::getId($contribution);
	$contributions->{$approvedBy} = $contribution;
}

sub addContributionToCSV{
	my ($filePath, %hash) = @_;
	
	open(OUTPUT, '>>' . $filePath) or die "Unable to open file: $filePath";
	
	my @values = values %hash;
	my $line = "";
	
	for (my $i = 0; $i < scalar(@values); $i++){
		if($i == scalar(@values) - 1){
			$line = $line . @values[$i] . "\n";
		}
		else{
			$line = $line . @values[$i] . ",";
		}				
	}
	
	print OUTPUT $line;
	close(OUTPUT);
}

1;