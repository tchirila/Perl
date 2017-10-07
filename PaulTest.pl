use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

#use Switch;
require Data::Employee;
require DAO::EmployeeDao;
require DAO::ConnectionDao;


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




sub test()
{

	
	
	#my %employeeHash = DAO::EmployeeDao::getEmployee("0987992");
#	unless(%employeeHash)
#	{
#		print "\nno value  \n";
#	}
#	my $employee = $employeeHash{"0987992"};
#	my $emplName = $employee->{"name"};
#	print "\nEmployee = $emplName \n";
	


	#my %employeeHash = DAO::EmployeeDao::getEmployee("0987992");
	my %employeeHash = DAO::EmployeeDao::getAllEmployees();
	my @emplHashKeys = keys %employeeHash;  
	foreach my $month(@emplHashKeys) 
	{
		my $empl = $employeeHash{$month};
		my $emplName = $empl->{"name"};
		print "\nEmployee = $emplName \n";
	}
	
	
	
	
	
	
	print "\nCompleted Successfully";
		
	
}







test();

#testConnectionDao();










