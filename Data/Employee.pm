package Data::Employee;
use Data::Dumper;
$|=1;


sub new {
	my $class = shift;
	my $name= shift; 
	my $number = shift;
	my $dob = shift;
	my $salary = shift;
	my $emprC = shift;
	my $empeC = shift;
	my $employee = {
		"name" => $name,
		"number" => $number,
		"DOB" => $dob,
		"salary" => $salary,
		"rCont" => $emprC,
		"eCont" => $empeC,
	};
	
	bless($employee, $class);
	
#	printDetails($employee);
	
	return $employee;	
}


sub printDetails	{ ## Debugger
	my ($employee, $other) = @_;	
	print Dumper($employee);
	print"#---------------------\n";
	
	
}

1;