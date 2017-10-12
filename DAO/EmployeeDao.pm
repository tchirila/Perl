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

		my $newEmp = new Data::Employee($fields[0], $fields[1], $fields[2], $fields[3], $fields[4], $fields[5],
			$fields[6], $fields[7], $fields[8], $fields[9], $fields[10], $fields[11],);
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
#	print OUTPUT "id,Name,number,DOB,salary,employer_contribution,employee_contribution,role,pass,charity,start_date,annual_contr\n"; ##Header
#	foreach my $value (values $hash)
#	{
#		my $line = Data::Employee::getId($value).","
#			.Data::Employee::getName($value).","
#			.Data::Employee::getNumber($value).","
#			.Data::Employee::getDOB($value).","
#			.Data::Employee::getSalary($value).","
#			.Data::Employee::getEmployerContribution($value).","
#			.Data::Employee::getEmployeeContribution($value).","
#			.Data::Employee::getEmployeeRole($value).","
#			.Data::Employee::getEmployeePassword($value).","
#			.Data::Employee::getCharityId($value).","
#			.Data::Employee::getStartDate($value).","
#			.Data::Employee::getAnnualContribution($value)."\n";
#		print OUTPUT $line;
#	}
#	close(OUTPUT);
#}





####################################
# pb - database methods
####################################

# Persists an new Data::Employee
#Param Data::Employee
sub addEmployee
{
	# prepare db connection
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $stmtEmplIns = $connection->prepare('insert into employees (name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date, annual_contr) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'); 
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
	my $annualC = $empl->{"annual_contr"};

	unless($stmtEmplIns->execute($name, $number, $dob, $salary, $emprC, $empeC, $role, $pass, $charityId, $startDate, $annualC))   
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
		                                  $row->{"charity_id"}, $row->{"start_date"}, $row->{"annual_contr"});
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
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date, annual_contr from employees where empl_num = ? ';
	           
	my $stmtGetEmpl = $connection->prepare($sql);
	unless(defined($stmtGetEmpl))
	{
		die "Could not prepare statement for export from db\n";
	}

	unless($stmtGetEmpl->execute($employNum))
	{
		die "Could not retrieve employee $employNum from db\n";
	}

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return %hash;
}



# returns a hash of all employees (employee number / Data::Employee)
sub getAllEmployees()  
{ 
	# prepare db connection 
	my $connection = DAO::ConnectionDao::getDbConnection();
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr, role, pass, charity_id, start_date, annual_contr from employees ';
	my $stmtGetEmpl = $connection->prepare($sql);
	
	unless(defined($stmtGetEmpl))
	{
		die "Could not prepare statement for export from db\n";
	}

	unless($stmtGetEmpl->execute())
	{
		die "Could not retrieve employees from db\n";
	}

	my %hash = readEmployees($stmtGetEmpl);
	$stmtGetEmpl->finish();
	DAO::ConnectionDao::closeDbConnection($connection);
	return %hash;
} 


sub initSystem()
{
	my %emplHash = getAllEmployees();
	my @emplKeys = keys %emplHash;
	if (scalar(@emplKeys) == 0)
	{
		my $file = 'dataFiles/employeeRecords.csv';
		print "loading initial employees from file: $file - this is a one off operation....";
		%emplHash = getEmployeesFromCSV($file);   
		foreach my $emplKey(keys %emplHash) 
		{
			my $emplee = $emplHash{$emplKey};
			my $emplNum = $emplee->{"number"};
			my $emplChar = $emplee->{"charity_id"};
			if ($emplChar eq '-1')
			{
				$emplee->{"charity_id"} = undef;
			}
			
			print "\n$emplNum\n";
			print "\n$emplChar\n";
			addEmployee($emplee);  
		}
	}
}	
	

1;

