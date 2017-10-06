use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

require Data::Employee;
require DAO::EmployeeDao;
require DAO::ConnectionDao;

# use Dao::EmployeesDao qw(readEmployees writeEmployees);


$| = 1;

sub main {

	my $filePath = "dataFiles/employeeRecords.csv";
	my %employeesHash = DAO::EmployeeDao::getEmployeesFromCSV($filePath);

	foreach my $emp (keys %employeesHash) {
		print Dumper($employeesHash{$emp});
	}

}



main();
