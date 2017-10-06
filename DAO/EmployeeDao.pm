package DAO::EmployeeDao;
use strict;
use warnings;
use Data::Dumper;
use lib '..';
use Exporter qw(import);
require Data::Employee;

#@EXPORT_OK = qw(getEmployeesFromCSV getAllEmployeesDb);

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
#sub saveEmployeesToCSV	{
#	my ($hash, $file) = @_;
#	open(OUTPUT, '>'.$file) or die "Can't open file $file";
#	print OUTPUT "Name,number,DOB,salary,employer_contribution,employee_contribution\n"; ##Header
#	foreach my $value (values $hash) 
#	{
#		my $line = Data::Employee::getName($value).","
#			.Data::Employee::getNumber($value).","
#			.Data::Employee::getDOB($value).","
#			.Data::Employee::getSalary($value).","
#			.Data::Employee::getEmployerContribution($value).","
#			.Data::Employee::getEmployeeContribution($value)."\n";
#		print OUTPUT $line;
#	}
#	close(OUTPUT);
#}

####################################################################################################

#######  PB in progress     
sub addEmployee()
{
	my $data = shift;
	
	# first do check that an employee of this number does not already exist
	
	# get this connection from the connection class + close it there 
	my $connection = DBI-> connect("dbi:mysql:bands", "JoeRoot", "J03R00tABC1234");
	
	
	
	my $stmtEmplIns = $connection-> prepare('insert into employees (name, empl_num, dob, salary, ' .
	                                     ' employee_contr, employer_contr) values (?, ?, ?, ?, ?, ?)');
	unless($stmtEmplIns)   
	{
		die ("Error preparing employee insert SQL\n");	
	}

    # just for testing
	my $name = "Paul";
	my $number = "098789"; 
	my $dob; #  = "DOB";
	my $salary = 10000; 
	my $emprC = 3; 
	my $empeC = 4;	
	unless($stmtEmplIns->execute($name, $number, $dob, $salary, $emprC, $empeC))
	{
		die "Error executing SQL\n";
	}  
		
	$stmtEmplIns->finish();
	$connection->disconnect();
}



#######  PB in progress 
sub getAllEmployees()
{
	my $connection = DBI-> connect("dbi:mysql:pensions", "JoeRoot", "J03R00tABC1234");
	
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr from employees '; 
	my $stmtAllEmpls = $connection->prepare($sql);
	unless(defined($stmtAllEmpls))
	{
		die("Could not prepare statement for export from db\n");
	}
	
	unless($stmtAllEmpls->execute())
	{
		die "Statement could not retrieve employees data from db\n";
	}
    
    # 
    my @data;
       
    while(my $row = $stmtAllEmpls->fetchrow_hashref())
	{
		my $emplId = $row->{"id"};
		my $name = $row->{"name"};
		my $number = $row->{"empl_num"}; 
		my $dob = $row->{"dob"};
		my $salary = $row->{"salary"}; 
		my $employeeC = $row->{"employee_contr"}; 
		my $employerC = $row->{"employer_contr"};	
		
		my $employee = new Data::Employee($emplId, $name, $number, $dob, $salary, $employeeC, $employerC);
		push @data, $employee;
	}	
    
	$stmtAllEmpls->finish();
	$connection->disconnect();
	close OUTPUT;

	return @data;
}


#####  PB in progress
sub getAllEmployeesOnWorkAnniversaryDate()
{
	# collect a date input
	
	
}


######  PB in progress
sub getEmployee()
{
	
	
}



######  PB in progress
sub removeEmployee()
{
	print "testing in remove employee";
	
	
}



1;