use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
require Data::Employee;
require DAO::EmployeeDao;
require DAO::ConnectionDao;
require Contribution::ContributionEngine;
require Utilities::Time;
require DateTime::Duration;
use DateTime qw( );


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


	my $employeeNum = 289;
	my %employeeHash = DAO::EmployeeDao::getEmployee($employeeNum);
	
	unless(defined(\%employeeHash))
	{
		print "asd";
	}
	
	unless(%employeeHash)
	{
		print "\nno value  \n";
	}
	my $employee = $employeeHash{$employeeNum};
	my $emplName = $employee->{"name"};
	print "\nEmployee = $emplName \n";
	

#	my %employeeHash = DAO::EmployeeDao::getAllEmployees();
#	my @emplHashKeys = keys %employeeHash;  
#	foreach my $month(@emplHashKeys) 
#	{
#		my $empl = $employeeHash{$month};
#		my $emplName = $empl->{"name"};
#		print "\nEmployee = $emplName \n";
#	}
#	

}	



#############################################################

#require Utilities::Time;
#require DateTime::Duration;

	# get the last day of each month
#	my $pYr = 2017;
#	my $dt1 = DateTime->new( year => $pYr, month => 8, day => 31 );
#	$dt1->add( months => 1, end_of_month => 'limit' );
#	print "\n\nPrint " . $dt1;
	
#	# add a year	
#	my $pYr = 2016;
#	my $dt1 = DateTime->new( year => $pYr, month => 2, day => 29 );
#	$dt1 = $dt1->add( years => 1, end_of_month => 'limit' );
#	print "\n\nPrint " . $dt1 . "\n";
##	
#	my $pYr2 = 2015;
#	my $dt2 = DateTime->new( year => $pYr2, month => 3, day => 29 );
#	$dt2 = $dt2->add( years => 1, end_of_month => 'limit' );
#	print "\n\nPrint 2 " . $dt2 . "\n";
#
#
#	# compare dates
#	my $cmp = DateTime->compare( $dt1, $dt2 );
#	print "\n\nXXX $cmp \n";

 
 # WRITE FROM DATETIME TO DB FORMAT
#my $dt1   = DateTime->now;  
#my $date = $dt1->ymd;   
#my $time = $dt1->hms;   
#my $wanted = "$date $time";  
#print "\n WANTED " . $wanted .  "\n";
#my $test = $dt1->month;   # 
#print "\n$test\n";

# WRITE FROM DB FORMAT TO DATETIME 
#	my $dt = DateTime::Format::MySQL->parse_datetime('2017-03-16 23:12:01');
#	my $test = $dt->year;   # year month day hour minute second ymd hms
#	my $test2 = $dt->month;
#	
#	print "\nYEAR = $test\n";
#	print "\nMonth = $test2  \n";
# There's also a parse_date() and a parse_timestamp() method.


#sub test2() 
#{
#		
#	# add a year	
#	my $pYr = 2016;
#	my $dt1 = DateTime->new( year => $pYr, month => 2, day => 29 );
#	$dt1 = $dt1->add( years => 1, end_of_month => 'limit' );
#	print "\n\nPrint " . $dt1 . "\n";
##	
#	my $pYr2 = 2015;
#	my $dt2 = DateTime->new( year => $pYr2, month => 3, day => 29 );
#	$dt2 = $dt2->add( years => 1, end_of_month => 'limit' );
#	print "\n\nPrint 2 " . $dt2 . "\n";
#
#
#	# compare dates
#	my $cmp = DateTime->compare( $dt1, $dt2 );
#	print "\n\nXXX $cmp \n";
#}

#	my( $year, $month ) = qw( 2012 2 );
#
#	my $date = DateTime->new(
#	    year  =>  $year,
#	    month => $month,
#	    day   => 1,
#	);
#	
#	my $date2 = $date->clone;
#	
#	$date2->add( months => 1 )->subtract( days => 1 );
#	
#	print "\n" . $date->ymd('-');
#	print "\n" . $date2->ymd('-');
#

##########################################################

# parse_date() + parse_timestamp() +  


sub test3() 
{
	# WRITE FROM DB FORMAT TO DATETIME 
	#'2017-03-16 23:12:01');    # '2017-10-09'   # '2017-10-11 12:09:54'
	
#	my $dteStr = '2016-01-27 00:00:00';
#	#my $dteStr = '2017-10-09';
#	my $dateObj = Contribution::ContributionEngine::createDateTimeObject($dteStr);
#	my $outputStr = Contribution::ContributionEngine::getDateStr($dateObj);
#	print "\nOutput = $outputStr\n";
#
##	print "\nIncrement by year:\n";
##	$dateObj = Contribution::ContributionEngine::incrementDateByYear($dateObj);
##	$outputStr = Contribution::ContributionEngine::getDateStr($dateObj);
##	print "\nOutput = $outputStr\n";
##	
#	print "\nIncrement to last day of next month:\n";
#	$dateObj = Contribution::ContributionEngine::incrementDateToLastDayOfNextMonth($dateObj);
#	$outputStr = Contribution::ContributionEngine::getDateStr($dateObj);
#	print "\nOutput = $outputStr\n";
	
	
	
# TEST 	  loadContributionHash()
#	our $MONTHLY_EMPLOYEE_CONTIBUTIONS = "E";
#our $MONTHLY_EMPLOYER_CONTIBUTIONS = "C";
#our $ANNUAL_EMPLOYER_CONTIBUTIONS = "A";
#	my %emplIdToLastContrDate = Contribution::ContributionEngine::loadContributionHash("A");
#	while(my ($emplId, $dateStr) = each %emplIdToLastContrDate)
#	{  
#		print "\n emplId: $emplId  AND dateStr =  $dateStr\n";
#	}
	
	
	#  TEST   getMissingContrDatesForEmployeeInAscOrder()
#	my $effDate = "2016-10-10 00:00:00"; 
#	my $startDate = "2009-10-09";
#	my $monthOrAnnual = 0;
#	my @missinDates = Contribution::ContributionEngine::getMissingContrDatesForEmployeeInAscOrder($effDate, $startDate, $monthOrAnnual);
#	foreach my $miss(@missinDates)
#	{
#		print "\nMissing date:  $miss\n";
#	}


# TEST saving process records.....
#	my $currSysTime = "2016-10-10 00:00:00"; 
#	my $currUserId = "7"; # 18
#	my $annualCount = 44; 
#	my $mnthEmpleeCount = 333; 
#	my $mnthEmplerCount = 47;
#	Contribution::ContributionEngine::updateSystemProcessRecords($currSysTime, $currUserId, $annualCount, $mnthEmpleeCount, $mnthEmplerCount);


	
#	my $inputDateStr = "2017-10-08 12:04:03";
#	#my $inputDateStr = "2017-10-08";
#	#my $date = Contribution::ContributionEngine::createDateObject($inputDateStr);
#	my $date = Contribution::ContributionEngine::createDateTimeObject($inputDateStr);
#	my $dateStr = Contribution::ContributionEngine::getDateStr($date);
#	print "\ndate = $dateStr \n";


#	my $timeNow = DateTime->now;
#	my $timeNow2 = Utilities::Time::getCurrentTimestampTime(); 	
#	print "\n$timeNow\n";
#	print "\n$timeNow2\n";


	Contribution::ContributionEngine::generateAnnualAnniversaryContributions();
	
	
    print "\nCompleted\n";
}




############################################################	


#loadContributionHash();
#test1();
#test2();
test3();
#test4();
#testConnectionDao();


#testEngine();









