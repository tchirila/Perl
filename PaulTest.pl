use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

#use Switch;
require Data::Employee;
require DAO::EmployeeDao;
require DAO::ConnectionDao;
require Contribution::ContributionEngine;
require Utilities::Time;

#use Date::Simple;


# use Dao::EmployeesDao qw(readEmployees writeEmployees);



$| = 1;

#use Dao::EmployeesDao qw(removeEmployee);



# use Dao::EmployeesDao qw(readEmployees writeEmployees);
#--------
#sub main {
#
#	my $filePath = "dataFiles/employeeRecords.csv";
#	my %employeesHash = DAO::EmployeeDao::getAllEmployees($filePath);
#	foreach my $emp (keys %employeesHash) {
#		print Dumper($employeesHash{$emp});
#	}
#	
#}


########################



#sub testConnectionDao()
#{
#	my $connection = DAO::ConnectionDao::getDbConnection();
#	unless(defined($connection))
#	{
#		print "MAIN:  connection undefined";
#	}
#	
#	print "connection open\n";
#	
#	DAO::ConnectionDao::closeDbConnection($connection);
#	
#	print "finish";
#}




sub test1()
{
	
#	my $startDate = '2017-10-10'; #Utilities::Time::getCurrentTimestampDate();
#	print "start date = $startDate";
#	my $dob = '2017-10-10'; #Utilities::Time::getCurrentTimestampDate(); 
#	my $employee = new Data::Employee(-1, "Sally", "51", $dob, 10000, 3, 5, "A", "pass1", 1, $startDate, 4);   
#    my $number = $employee->{"number"}; 
#    print "\ntest() no = $number\n";
#    my $result = DAO::EmployeeDao::addEmployee($employee);
#    if ($result == 1)
#    {
#    	print "\nGOOD\n";
#    }
#    else
#    {
#    	print "\nBAD\n";
#    }

	
#	my $employeeNum = 51;
#	my $result = DAO::EmployeeDao::removeEmployee($employeeNum);
#    if ($result == 1)
#    {
#    	print "\nGOOD\n";
#    }
#    else
#    {
#    	print "\nBAD\n";
#    }


#	my $employeeNum = 28;
#	my %employeeHash = DAO::EmployeeDao::getEmployee($employeeNum);
#	unless(%employeeHash)
#	{
#		print "\nno value  \n";
#	}
#	my $employee = $employeeHash{$employeeNum};
#	my $emplName = $employee->{"name"};
#	print "\nEmployee = $emplName \n";
	

#	my %employeeHash = DAO::EmployeeDao::getAllEmployees();
#	my @emplHashKeys = keys %employeeHash;  
#	foreach my $month(@emplHashKeys) 
#	{
#		my $empl = $employeeHash{$month};
#		my $emplName = $empl->{"name"};
#		print "\nEmployee = $emplName \n";
#	}
#	
	
	# TEST ANNUAL CALC
	# my $contrAmount = ($emplAnnualEmployeeContr / 100) * $emplSalary;
	
	
	# TEST MONTHLY CALC


	

    # print "\nCompleted Successfully";
		
	
}



sub testEngine() 
{
	
	print "\nStarting...\n";
	#Contribution::ContributionEngine::generateEndOfMonthContributions();
	
	#print "local time = " . localtime();
	
	
	my $calcAmount = (1 / 100) * 10000;
	print "Calculation amount = $calcAmount";
	
	
	
	
	print "\nCompleted\n";
	
		
	
} 








test1();
#testConnectionDao();

#testEngine();









