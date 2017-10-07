package DAO::EmployeeDao;
use strict;
use warnings;
use Data::Dumper;
use lib '..';
use Exporter qw(import);
require Data::Employee;
require DAO::ConnectionDao;


my @EXPORT_OK = qw(addEmployee removeEmployee getEmployee getAllEmployees);


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



# pb in progress
sub addEmployee()
{
	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $stmtEmplIns = $connection->prepare('insert into employees (name, empl_num, dob, salary, employee_contr, employer_contr) values (?, ?, ?, ?, ?, ?)');
	
	unless($stmtEmplIns)   
	{
		die ("Error preparing employee insert SQL\n");	
	}
   
	my ($name, $number, $dob, $salary, $emprC, $empeC) = @_;   # TODO  need to check the mandatory values are not undefined & date is a date
	$dob = undef;  # TODO need to add date 
	unless($stmtEmplIns->execute($name, $number, $dob, $salary, $emprC, $empeC))
	{
		print "Error executing SQL\n";
		return 0;
	}  
	
	print "Employee number $number added successfully....\n";
		
	$stmtEmplIns->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return 1;
}



# pb in progress
#Param1: Employee number
sub removeEmployee()
{
	my $employNum =  shift;   # TODO add checking

	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $error;
	$connection->do("delete from employees where empl_num = '$employNum'") or $error = "Failed to delete";
	DAO::ConnectionDao::closeDbConnection($connection);
	
	if(defined($error))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}



# pb in progress
#Param1: Db prepared statement
sub readEmployees
{
	my $stmtGetEmpl = shift;
	my %hash;
	while(my $row = $stmtGetEmpl->fetchrow_hashref())
	{
		my $id = $row->{"id"};
		my $name = $row->{"name"};
		my $num = $row->{"empl_num"};
		my $dob = $row->{"dob"};
		my $salary = $row->{"salary"};
		my $empleeContr = $row->{"employee_contr"};
		my $emplerContr = $row->{"employer_contr"};

		# create and return a hash of Employee
		my $employee = new Data::Employee($id, $name, $num, $dob, $salary, $empleeContr, $emplerContr);
		hashAddEmployee(\%hash, $employee);		
		return %hash;
	}
}




# pb in progress
#Param1: Employee number
sub getEmployee() 
{
	my $employNum =  shift;     # TODO add checking
	
	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr from employees where empl_num = ? '; 
	my $stmtGetEmpl = $connection->prepare($sql);
	unless(defined($stmtGetEmpl))
	{
		die("Could not prepare statement for export from db\n");
	}
	
	unless($stmtGetEmpl->execute($employNum))
	{
		die "Could not retrieve employee $employNum from db\n";
	}

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	return %hash;	
}



# pb in progress
sub getAllEmployees()  # TODO  fix BUG here: only returning single employee
{
	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr from employees'; 
	my $stmtGetEmpl = $connection->prepare($sql);
	unless(defined($stmtGetEmpl))
	{
		die("Could not prepare statement for export from db\n");
	}
	
	unless($stmtGetEmpl->execute())
	{
		die "Could not retrieve employees from db\n";
	} 

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	return %hash;	
}


1;