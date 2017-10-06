package DAO::EmployeeDao;
use Exporter qw(import);
use lib '..';
use DBI;
require Data::Employee;

@EXPORT_OK = qw(getAllEmployees addEmployee getAllEmployeesDb);

$|=1;




#######  PB in progress
sub addEmployee()
{
	my $data = shift;
	
	# first do check that an employee of this number does not already exist
	
	# get this connection from the connection class + close it there 
	my $connection = DBI-> connect("dbi:mysql:bands", "JoeRoot", "J03R00tABC1234");
	
	unless(defined($dbHandle))
	{
		die("Could not access database\n");
	}
	
	my $stmtEmplIns = $dbHandle->prepare('insert into employees (name, empl_num, dob, salary, ' .
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
sub getAllEmployeesDb()
{
	$connection = DBI-> connect("dbi:mysql:pensions", "JoeRoot", "J03R00tABC1234");
	unless(defined($dbHandle))
	{
		die("Could not access database\n");
	}
	print("Connected to database \n");
	
	my $sql = 'select id, name, empl_num, dob, salary, employee_contr, employer_contr from employees '; 
	my $stmtAllEmpls = $dbHandle->prepare($sql);
	unless(defined($stmtGetStuff))
	{
		die("Could not prepare statement for export from db\n");
	}
	
	unless($stmtGetStuff->execute())
	{
		die "Statement could not retrieve employees data from db\n";
	}
    
    # 
    my @data;
       
    while(my $row = $stmtGetStuff->fetchrow_hashref())
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
    
	$stmtGetStuff->finish();
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
	
	
	
}


1;

