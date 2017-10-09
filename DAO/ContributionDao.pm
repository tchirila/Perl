package DAO::ContributionDao;

use strict;
use warnings;

require Data::Contribution;
require DAO::ConnectionDao;
require Utilities::Time;

sub getAllContributionsForEmployeeId{
	my $employeeId = shift;
	
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $query = "select * from contributions where employees_id = $employeeId";
	my $preparedQuery = $connection->prepare($query);
	
	unless(defined($preparedQuery)){
		die "Error preparing contribution SQL query\n";
	}
	
	unless($preparedQuery->execute()){
		die "Error executing get all contributions for employee id SQL query\n";
	}
	
	my @contributions = readContributions($preparedQuery);
	$preparedQuery->finish();
	return @contributions;
}

sub readContributions{
	my $preparedQuery = shift;
	my @contributions;
	
	while(my $record = $preparedQuery->fetchrow_hashref()){
		my %hash;
		
		my $id = $record->{"id"};
		my $type = $record->{"type"};
		my $contr_pc = $record->{"contr_pc"};
		my $contr_amount = $record->{"contr_amount"};
		my $salary = $record->{"salary"};
		my $processed_date = $record->{"processed_date"};
		my $effective_date = $record->{"effective_date"};
		my $employees_id = $record->{"employees_id"};
		my $charity_id = $record->{"charity_id"};
		
		my $contribution = new Data::Contribution($id, $type, $contr_pc, $contr_amount, $salary, $processed_date, $effective_date, $employees_id, $charity_id);
		hashAddContribution(\%hash, $contribution);
		push @contributions,\%hash;
	}
	
	return @contributions;
}

sub addContribution{
	my ($type, $contr_pc, $contr_amount, $salary, $effective_date, $employees_id, $charity_id) = @_;
	
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $query = 'insert into contributions (type,contr_pc,contr_amount,salary,process_date,effective_date,employees_id,charity_id) values (?, ?, ?, ?, ?, ?, ?, ?)';
	my $preparedQuery = $connection->prepare($query);
	
	unless(defined($preparedQuery)){
		die "Error preparing contribution SQL query\n";
	}
	
	my $process_date = Utilities::Time::getCurrentTimestamp();
	
	unless($preparedQuery->execute($type, $contr_pc, $contr_amount, $salary, $process_date, $effective_date, $employees_id, $charity_id)){
		print "Error executing add contribution SQL query\n";
		return 0;
	}
	
	$preparedQuery->finish();
	#DAO::ConnectionDao::closeDbConnection($connection);
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
	my $id = Data::Contribution::getId($contribution);
	$contributions->{$id} = $contribution;
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