use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

require Data::Employee;
require DAO::EmployeeDao;
require DAO::CharityDao;
require DAO::ConnectionDao;

#use Dao::EmployeesDao qw(readEmployees writeEmployees);


$| = 1;


my $EMPLOYEE_FILE = "dataFiles/employeeRecords.csv";
my $CHARITY_FILE = "dataFiles/charities.csv";

sub main {

	#my $filePath = "dataFiles/employeeRecords.csv";
	my %employeesHash = DAO::EmployeeDao::getEmployeesFromCSV($EMPLOYEE_FILE);
	foreach my $emp (keys %employeesHash) {
		print Dumper($employeesHash{$emp});
	}


}

sub charity	{
	#my $charityFile = "dataFiles/charities.csv";
	my %charitiesHash = DAO::CharityDao::getCharitiesFromCSV($CHARITY_FILE);
	foreach my $charity (keys %charitiesHash) {
		print Dumper($charitiesHash{$charity});
	#	print Dumper(DAO::CharityDao::hashGetCharity(\%charitiesHash,$charity));
	}




}

##-----------------------------------------------------------------

#main();
#charity();



