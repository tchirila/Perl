package DAO::EmployeeDao;
use Exporter qw(import);
use lib '..';
use DBI;
require Data::Employee;

@EXPORT_OK = qw(getAllEmployees addEmployee getAllEmployeesDb);

$|=1;

my $DATABASE = "pensions"; 
my $DB_USERNAME = "JoeRoot";
my $DB_PASS = "J03R00tABC1234";

my $connection;


######  Alf
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


#####  Alf
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






#######  PB in progress
sub addEmployee()
{
	my $data = shift;
	
	# first do check that an employee of this number does not already exist
	
	# get this connection from the connection class + close it there 
	$connection = DBI-> connect("dbi:mysql:bands", "JoeRoot", "J03R00tABC1234");
	
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