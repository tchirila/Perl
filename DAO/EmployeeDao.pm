package DAO::EmployeeDao;
use strict;
use warnings;
use Data::Dumper;

require Data::Employee;
$|=1;


#Param1: FileName.
sub getEmployeesFromCSV	{
	my $inFile = shift;
	open(INPUT,$inFile) or die ("Missing file: $inFile");
	my @headers = split /\s*,\s*/, <INPUT>;
	
	my %hash;
	LOOP1: while(my $line = <INPUT>)	{
		$line =~ /\S+/ or next LOOP1; ## Skip blank lines.
		chomp $line;
		my @fields = split /\s*,\s*/, $line; 
		if(scalar(@fields)<scalar(@headers))	{
			print "WARNING: Invalid row: $line";
			next LOOP1;
		}
		
		my $newEmp = new Data::Employee($fields[0], $fields[1], $fields[2], $fields[3], $fields[4], $fields[5],);
		hashAddEmployee(\%hash, $newEmp);
	} 	
	close INPUT;
	return %hash;
}


## Param1: employees hash.
##Param2: employee number.
sub hashGetEmployee	{
	my ($employees, $num) = @_;
	my $employee = $employees->{$num};
	return $employee;
}


#Param1: Employees array.
#Param2: Employee to be removed.
sub hashRemoveEmployee	{
	my $hash = shift;
	my $empNum = shift;
	delete($hash->{$empNum});
}

#Param1: Employees hash.
#Param2: Employee object.
sub hashAddEmployee	{
	my ($hash, $emp) = @_;
	my $empNum = Data::Employee::getNumber($emp);
	$hash->{$empNum} = $emp;
}

#Param1: Employees hash.
#Param2: filename.
sub saveEmployeesToCSV	{
	my ($hash, $file) = @_;
	open(OUTPUT, '>'.$file) or die "Can't open file $file";
	print OUTPUT "Name,number,DOB,salary,employer_contribution,employee_contribution\n"; ##Header
	foreach my $value (values $hash) {
		my $line = Data::Employee::getName($value).","
			.Data::Employee::getNumber($value).","
			.Data::Employee::getDOB($value).","
			.Data::Employee::getSalary($value).","
			.Data::Employee::getEmployerContribution($value).","
			.Data::Employee::getEmployeeContribution($value)."\n";
		print OUTPUT $line;
	}
	close(OUTPUT);
}


1;