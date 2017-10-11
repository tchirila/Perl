package Contribution::ContributionEngine;
use strict;
use warnings;
use Data::Dumper;
use lib '..';
use Exporter qw(import);
require Data::Contribution;
require Data::Employee;
require DAO::EmployeeDao;
require DAO::ConnectionDao;
require DAO::ContributionDao;
require Utilities::Time;
require Date::Calc;
require DateTime::Duration;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL
require DateTime::Duration;

use DateTime qw( );









my @EXPORT_OK = qw(updateContributions); 

$|=1;

our $MONTHLY_EMPLOYEE_CONTIBUTIONS = "E";
our $MONTHLY_EMPLOYER_CONTIBUTIONS = "C";
our $ANNUAL_EMPLOYER_CONTIBUTIONS = "A";


# Single point of access for this class to update the system for
# a) annual contributions on anniversary of each employee
# b) monthly contributions for employee and employer
#param: id of the current user (ie their employee id) 
sub generateAnnualAnniversaryContributions()
{
	my $currUserId = shift;
	unless(defined($currUserId))
	{
		# current user not known / is system
		$currUserId = -1;	
	}
	
	# prepare to record how many contributions records are created in this process
	my $annualCount = 0;
	my $mnthEmpleeCount = 0;
	my $mnthEmplerCount = 0;

	my $currSysTime = Utilities::Time::getCurrentTimestampDate();
	
	# loop through each employee on system
	my %employees = DAO::EmployeeDao::getAllEmployees();
	while(my ($key, $value) = each %employees)  # each functions contains an array of 2 values (ie $key, $value)
	{
		my $emplNum = $key;
		my $employee = $value;
		my $emplId = $employee->{"id"};
		my $charityId = $employee->{"charity_id"};
		my $emplSalary = $employee->{"salary"};  
		my $emplerContr = $employee->{"rCont"}; 
		my $empleeContr = $employee->{"eCont"};
		my $emplAnnualEmployeeContr = $employee->{"annual_contr"};  
		
		# find the start date for this employee
		my $emplStartDate = $employee->{"start_date"};
		
		# for this employee, get the most recent contribution effective date for each contribution type (type v date)
		my %typeToMostRecentEffDate = getLastDateContribution();  

		# manage update of annual anniversary contributions  		
		my $mostRecentAnnualContr = $typeToMostRecentEffDate{$ANNUAL_EMPLOYER_CONTIBUTIONS};
		my @missingAnnualEffDates = getMissingAnnualContrDatesForEmployee($mostRecentAnnualContr); 
		foreach my $effectiveDate(@missingAnnualEffDates)   
		{
			# create a new contribution record and persist it
			my $annContr = ($emplAnnualEmployeeContr / 100) * $emplSalary;   ## SUBROUTINE  !!!!
			my $contributionObj = new Data::Contribution(-1, $ANNUAL_EMPLOYER_CONTIBUTIONS, $emplAnnualEmployeeContr, $annContr, 
			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
			## TODO  save to database here
			$annualCount++;  
		}		
		
		# manage update of monthly contributions (assumes employer / employee monthly contribution dates will match)
		my $mostRecentMthEffDate = $typeToMostRecentEffDate{$MONTHLY_EMPLOYEE_CONTIBUTIONS};
		my @missingMthEffDates = getMissingMnthContrDates($mostRecentMthEffDate);
		foreach my $effectiveDate(@missingMthEffDates)  
		{
			# create and persist new employee contribution record
			my $monthlyEmpleeContr = ($empleeContr / 100) * $emplSalary;    ## SUBROUTINE  !!!!
			my $monthlyEmpleeContrObj = new Data::Contribution(-1, $MONTHLY_EMPLOYEE_CONTIBUTIONS, $empleeContr, $monthlyEmpleeContr, 
			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
			## TODO  save to database here
			$mnthEmpleeCount++; 			                              
			                              
			# create and persist new employer contribution record                              
			my $monthlyEmplerContr = ($emplerContr / 100) * $emplSalary;    ## SUBROUTINE  !!!!
			my $monthlyEmplerContrObj = new Data::Contribution(-1, $MONTHLY_EMPLOYER_CONTIBUTIONS, $emplerContr, $monthlyEmplerContr, 
			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
			## TODO  save to database here
			$mnthEmplerCount++; 
		}
	}

	# create a new process completed record:  with $count, and persist		
	updateSystemProcessRecords($currSysTime, $currUserId, $annualCount, $mnthEmpleeCount, $mnthEmplerCount);
}



# Record a summary of the system update processes completed
#@Param: $currSysTime - current system date and time 
#@Param: $currUserId - id of the current user (employee id)
#@Param: $annualCount - number of annual contribution records created in this process 
#@Param: $mnthEmpleeCount - number of employee contribution records created in this process
#@Param: $mnthEmplerCount - number of employer contribution records created in this process
sub updateSystemProcessRecords( )
{
	my $currSysTime = shift; 
	my $currUserId = shift;
	my $annualCount = shift; 
	my $mnthEmpleeCount = shift; 
	my $mnthEmplerCount = shift;
	
	DAO::ProcessHistoryDao::addProcess($currSysTime, $currUserId, 1, $annualCount, $ANNUAL_EMPLOYER_CONTIBUTIONS);
	print "Successfully completed annual employee contribution update process on $currSysTime: $annualCount records persisted";

	DAO::ProcessHistoryDao::addProcess($currSysTime, $currUserId, 1, $mnthEmpleeCount, $MONTHLY_EMPLOYEE_CONTIBUTIONS);
	print "Successfully completed monthly employee contribution update process on $currSysTime: $mnthEmpleeCount records persisted";

	DAO::ProcessHistoryDao::addProcess($currSysTime, $currUserId, 1, $mnthEmplerCount, $MONTHLY_EMPLOYER_CONTIBUTIONS);
	print "Successfully completed monthly employer contribution update process on $currSysTime: $mnthEmplerCount records persisted";
}




# Get any anniversary dates for which there is no contribution record. 
# Return the array in ascending order
#@param - $lastContrDate
sub getMissingAnnualContrDatesForEmployee()
{
	my $lastContrDate = shift;   # ie start date   TODO check if undefined
	
	# define array of missing dates
	my @datesNoAnnualContr;
	
	# get $lastContrDate in DateTime form
	my $possContrDate = getDate($lastContrDate);
	
	# get now in Date time form
	my $timeNow = DateTime->now;
		
	# while date < now>  
	my $cmp = DateTime->compare($possContrDate, $timeNow);
	while ($cmp < 0)
	{
		# get datetime in string form and add to array
		my $possDateStr = getDateStr($possContrDate);
	    push @datesNoAnnualContr, $possDateStr;
		
	    # increment possContrDate by 1 year
		my $year = $possContrDate->year;
		my $month = $possContrDate->month;
		my $day = $possContrDate->day;
		$possContrDate = DateTime->new( year => $year, month => $month, day => $day);	
		
		# determine if vaue of possContrDate is now in the past
		$cmp = DateTime->compare($possContrDate, $timeNow);	
	}
	   
	return @datesNoAnnualContr;    	
}



#@Param - date in SQL form 
#@Returns - date in DateTime form
sub getDate()
{
	my $dateStr = shift;
	my $dt = DateTime::Format::MySQL->parse_datetime($dateStr);   # '2017-03-16 23:12:01'
	return $dt;
}


#@Param - date in DateTime form
#@Returns - date in SQL form 
sub getDateStr()
{
	my $date = shift;
	my $dateStr = $date->ymd;   
	my $timeStr = $date->hms;   
	return $dateStr . " " . $timeStr; 
}



# Get any anniversary dates for which there is no contribution record. 
# Return the list in ascending order
#@param - $lastContrDate
#@param - contributions type (see definitions at top)
sub getMissingMnthContrDates()
{
	
	
}




# Returns the date of the most recent contributions for the given employee of the given type 
#@param type - contributions type (see definitions at top)
#@param employee id - $emplId
sub getLastDateContribution()
{
	my $contrType = shift;
	my $emplId = shift;

	# better to get method:    
	my %contribution = DAO::ContributionDao::getAllContributionsForEmployeeId($emplId);
    # contrId v contribution

	# loop through all contributions, and for each type, get the most recent date	
    my %typeToMostRecentEffDate;     # type v date

	
	# TODO get this data from a new DAO::ContributionDao method and set the array of contribution hashes for all employees once  
			# do up top and pass in
	
	
	
	
	 
	#	contrId v Contribution
	
	
	
	return 0;
}   


1;



