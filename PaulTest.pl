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
#	my $startDate = Utilities::Time::getCurrentTimestampDate();
#	my $dob = Utilities::Time::getCurrentTimestampDate(); 
#	my $employee = new Data::Employee(-1, "Bobby", "41", $dob, 10000, 3, 5, "A", "pass1", 1, $startDate);  
#    
#    
#    my $number = $employee->{"number"}; 
#    print "\ntest() no = $number\n";
#    
#    
#    my $result = DAO::EmployeeDao::addEmployee($employee);
#    if ($result == 1)
#    {
#    	print "\nGOOD\n";
#    }
#    else
#    {
#    	print "\nBAD\n";
#    }

	
#	my $employeeNum = 24;
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
	

     print "\nCompleted Successfully";
		
	
}



sub testEngine() 
{
	
	print "\nStarting...\n";
	Contribution::ContributionEngine::generateEndOfMonthContributions();
	
	#print "local time = " . localtime();
	
	
	
	
	print "\nCompleted\n";
	
		
	
} 








#test();
#testConnectionDao();

testEngine();









