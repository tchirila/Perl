#use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

require Data::Employee;
require Data::ProcessHistory;
require DAO::EmployeeDao;
#require DAO::CharityDao;
require DAO::ConnectionDao;
require DAO::ContributionDao;
require DAO::ProcessHistoryDao;

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

sub contribution{
	my @response = DAO::ContributionDao::getAllContributionsForEmployeeId("1");
	foreach my $hash(@response){
		my $value = $hash->{"id"};
		print "$value" . "\n";
	}
}

sub testAddProcess{
	my $process = new Data::ProcessHistory();
	DAO::ProcessHistoryDao::addProcess($process);
}

##-----------------------------------------------------------------

#main();
#charity();
contribution();
#testAddProcess();


