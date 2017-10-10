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
			print "WARNING: Invalid row (".
				scalar(@fields)."/".scalar(@headers)." columns): '$line'\n";
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
#			.Data::Employee::getEmployeeContribution($value).","
#			.Data::Employee::getEmployeeRole($value).","
#			.Data::Employee::getEmployeePassword($value)."\n";
#		print OUTPUT $line;
#	}
#	close(OUTPUT);
#}





####################################
# pb - database methods
####################################

# Persists an new Data::Employee
#Param Data::Employee
sub addEmployee()
{
	# prepare db connection
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $stmtEmplIns = $connection->prepare('insert into employees (name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'); 
	unless($stmtEmplIns)
	{
		print "Error preparing employee insert SQL\n";
		return 0;
	}

	my $empl = shift;
	my $name = $empl->{"name"};
	my $number = $empl->{"number"};
	my $dob = $empl->{"DOB"}; 
	my $salary = $empl->{"salary"};
	my $emprC = $empl->{"rCont"};
	my $empeC = $empl->{"eCont"};
	my $role = $empl->{"role"};
	my $pass = $empl->{"pass"};
	my $charityId = $empl->{"charity_id"};
	my $startDate = $empl->{"start_date"};
	unless($stmtEmplIns->execute($name, $number, $dob, $salary, $emprC, $empeC, $role, $pass, $charityId, $startDate))   
	{
		print "Error executing SQL\n";
		return 0;
	}

	print "Employee number $number added successfully....\n";

	$stmtEmplIns->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return 1;
}


# removes the employee with the given Data::Employee number
#Param1: Employee number
sub removeEmployee()
{
	my $employNum =  shift;

	# prepare db connection
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $error;
	$connection->do("delete from employees where empl_num = $employNum") or $error = "Failed to delete";
	DAO::ConnectionDao::closeDbConnection($connection);
	if(defined($error))
	{
		return 0;
	}
	else
	{
		return 1;
	}
}


#Helper method for getting Data::Employee objects
#Param1: Db prepared statement
sub readEmployees
{
	my $stmtGetEmpl = shift;
	my %hash;
	while(my $row = $stmtGetEmpl->fetchrow_hashref()) 
	{
		# create and return a hash of Employee
		my $employee = new Data::Employee($row->{"id"}, $row->{"name"}, $row->{"empl_num"}, $row->{"dob"}, $row->{"salary"}, 
		                                  $row->{"employee_contr"}, $row->{"employer_contr"}, $row->{"role"}, $row->{"pass"},
		                                  $row->{"charity_id"}, $row->{"start_date"});
		hashAddEmployee(\%hash, $employee);
	}

	return %hash;
}



# returns a hash of the Data::Employee of the given number (employee number / Data::Employee)
#Param1: Employee number
sub getEmployee()
{
	my $employNum =  shift;  

	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date from employees where empl_num = ? ';
	           
	my $stmtGetEmpl = $connection->prepare($sql);
	unless(defined($stmtGetEmpl))
	{
		print "Could not prepare statement for export from db\n";
		return 0;
	}

	unless($stmtGetEmpl->execute($employNum))
	{
		print "Could not retrieve employee $employNum from db\n";
		return 0;
	}

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	return %hash;
}



# returns a hash of all employees (employee number / Data::Employee)
sub getAllEmployees()  
{ 
	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date from employees ';
	my $stmtGetEmpl = $connection->prepare($sql);
	
	unless(defined($stmtGetEmpl))
	{
		print "Could not prepare statement for export from db\n";
		return 0;
	}

	unless($stmtGetEmpl->execute())
	{
		print "Could not retrieve employees from db\n";
		return 0;
	}

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	return %hash;
} 


1;