package DAO::EmployeeDao;
use Data::Dumper;

require Data::Employee;
$|=1;



sub getAllEmployees	{
	my $inFile = shift;

	open(INPUT,$inFile) or die ("Missing file: $inFile");
	
	my @headers = split /\s*,\s*/, <INPUT>; ## Get headers.
#	print join ' | ', @headers;
	
	my %hash;
	LOOP1: while(my $line = <INPUT>)	{
		$line =~ /\S+/ or next LOOP1; ## Skip blank lines.
		chomp $line;
		my @fields = split /\s*,\s*/, $line; 
		if(scalar(@fields)<scalar(@headers))	{
			print "WARNING: Invalid row: $line";
			next LOOP1;
		}
		
		$hash{$fields[1]} = new Data::Employee($fields[0], $fields[1], $fields[2], $fields[3], $fields[4], $fields[5],);
		
	} 	
	close INPUT;
	return %hash;
}


#sub getEmployee	{
#	my @employees = shift;
#	my $ref = shift;
#	print "Employee count = ". scalar(@employees)."\n";
#	print Dumper($ref)." ...|\n";
#	
#	my $returnValue;
#	
#	for my $employee (@employees)	{
#		if($employee->{"name"} eq $ref)	{
#			print "We got it ($ref)!\n";
#			
#			print Dumper($employee)."\t\t NAILED IT!\n";
#			
#			$returnValue = $employee;
#		}
#		last;
#	}
#}



1;