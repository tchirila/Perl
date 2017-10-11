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
	
	# for each employee, record the last date of each type of contribution
	my %emplIdToLastContrDateTypeAnnual = loadContributionHash($ANNUAL_EMPLOYER_CONTIBUTIONS);
	my %emplIdToLastContrDateTypeMnthEmplr = loadContributionHash($MONTHLY_EMPLOYER_CONTIBUTIONS);
	my %emplIdToLastContrDateTypeMnthEmplee = loadContributionHash($MONTHLY_EMPLOYEE_CONTIBUTIONS);
	
	# loop through each employee on system
	my %employees = DAO::EmployeeDao::getAllEmployees();
	while(my ($key, $value) = each %employees) 
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
		
		# for this employee, get the most recent contribution effective date for the different contribution types
		# (could be undefined if none yet exist)
		my $mostRecentAnnualContr =  $emplIdToLastContrDateTypeAnnual{$emplId};
		my $mostRecentMnthEmplrContr =  $emplIdToLastContrDateTypeMnthEmplr{$emplId};
		my $mostRecentMnthEmpleeContr =  $emplIdToLastContrDateTypeMnthEmplee{$emplId};
		
		# manage update of annual anniversary contributions
		my @missingAnnualEffDates = getMissingContrDatesForEmployeeInAscOrder($mostRecentAnnualContr, $emplStartDate, 0);
		my $annContr = ($emplAnnualEmployeeContr / 100) * $emplSalary; 
		foreach my $effectiveDate(@missingAnnualEffDates)   
		{
			DAO::ContributionDao::addContribution($ANNUAL_EMPLOYER_CONTIBUTIONS, $emplAnnualEmployeeContr, $annContr, $emplSalary, 
										$effectiveDate, $emplId, $charityId);
			$annualCount++;  
		}		
		
		# manage update of monthly contributions (both employee and employer)
		# only applicable from the first full month in the company
		my @missingMthEffDates = getMissingContrDatesForEmployeeInAscOrder($mostRecentMnthEmpleeContr, $emplStartDate, 1);
		my $monthlyEmpleeContr = ($empleeContr / 100) * $emplSalary;
		my $monthlyEmplerContr = ($emplerContr / 100) * $emplSalary;
		foreach my $effectiveDate(@missingMthEffDates)  
		{
			# persist any new employee contributions
			DAO::ContributionDao::addContribution($MONTHLY_EMPLOYEE_CONTIBUTIONS, $empleeContr, $monthlyEmpleeContr, $emplSalary, 
										$effectiveDate, $emplId, $charityId);    
			$mnthEmpleeCount++; 
			
			# persist any new employer contributions
			DAO::ContributionDao::addContribution($MONTHLY_EMPLOYER_CONTIBUTIONS, $emplerContr, $monthlyEmplerContr, $emplSalary, 
										$effectiveDate, $emplId, $charityId);
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



# Get any array any dates up to today for which there is currently no contribution record. 
# Return the array in ascending order
#@param - $mostRecentContr - the date of the most recent contribution (if one exists)
#         note that this vaue may be undefined if it does not exist
#@param - employee start date 
#@param - an number to describe if deling with annual of monthly contributions (0 = annual, 1 == monthly)    
sub getMissingContrDatesForEmployeeInAscOrder()
{
	my $mostRecentContr = shift;  
	my $empleeStartDate = shift;
	my $incrementType = shift;
	unless(defined($mostRecentContr))
	{
		$mostRecentContr = $empleeStartDate;   # TODO does this need cloning?????   strings........
	}
	
	# define array of missing dates
	my @datesNoContr;
	
	# suggest the first possible date that may be due a contribution
	my $baseContrDate = getDate($mostRecentContr);
	my $possContrDate = incrementDate($incrementType, $baseContrDate);
	
	# get the time now in object form
	my $timeNow = DateTime->now;
		
	# record any other missing contribution dates  
	my $allContrDatesRead = DateTime->compare($possContrDate, $timeNow);
	while ($allContrDatesRead <= 0)
	{
		# get datetime in string form and add to array
		my $possDateStr = getDateStr($possContrDate);
	    push @datesNoContr, $possDateStr;
		
	    # increment possContrDate by 1 year
		$possContrDate = incrementDate($incrementType, $possContrDate);
		
		# determine if value of possContrDate is now in the past
		$allContrDatesRead = DateTime->compare($possContrDate, $timeNow);	
	}
	   
	return @datesNoContr;    	
}




# Increments date according to whether this is montly or annual contributions 
#@param - an number to describe if deling with annual of monthly contributions (0 = annual, 1 == monthly)
#@param - the datetime field
#@Return - the incremented date
sub incrementDate()
{
	my $incrementType = shift;
	my $date = shift;
	if ($incrementType eq 0) 
	{
		return incrementDateByYear($date);	
	}
	else 
	{
		return incrementDateToLastDayOfNextMonth($date);	
	}
}	




# Loads hash mapping each employee id with the latest date
#@param type - contributions type (see definitions at top)
#              Possible types:
               # $ANNUAL_EMPLOYER_CONTIBUTIONS
               # $MONTHLY_EMPLOYEE_CONTIBUTIONS
               # $MONTHLY_EMPLOYER_CONTIBUTIONS
# Returns - hash mapping each employee id with the latest date for the given contributions type              
sub loadContributionHash()
{
	my $reqType = shift;   # TODO for simplicity, loop through each time separately for now, calling loadContributionHash() 3 times
	                       # TODO eventually, put all together into a hash
	
	# map each employee id against the last contribution record's 'effective_date' field
	my %emplIdToLastContrDate;
		
	# get all contributions on system regardless of their employee id, in descending order
	my @contribution = DAO::ContributionDao::getAllContributions();
	
	foreach my $contr(@contribution)
	{
		my $emplId = $contr->{"employees_id"};
		my $effDate = $contr->{"effective_date"};
		my $type = $contr->{"type"};
		
		if ($type eq $reqType)
		{
			my $emplInMap = $emplIdToLastContrDate{$emplId};
			unless(defined($emplInMap))
			{
				my $testValue = $emplIdToLastContrDate{$emplId};

				# no contributions stored for this type, so add to hash: employee id v date
				$emplIdToLastContrDate{$emplId} = $effDate;
			}
		}
	}
	
	return %emplIdToLastContrDate;
}


# Gets the date forward one calendar year - in the case of 29th Feb, the following 28th Feb is returned
#@Param - the date to be incremented by 1 year
#@Returns - the modified datetime object   
sub incrementDateByYear()
{
	my $date = shift;
	return $date->add( years => 1, end_of_month => 'limit' );
}



# Gets the last day of the following month
#@Param - the date string to be incremented to the last day of following month
#@Returns - the modified datetime object
sub incrementDateToLastDayOfNextMonth()
{
	my $date = shift;
	return $date->add( months => 1, end_of_month => 'limit' );
}



# Converts a string date into a specific datetime object (with default time values)
#@Param - the datetime object 
sub createDateObject()
{
	my $date = shift;
	my $year = $date->year;
	my $month = $date->month;
	my $day = $date->day;
	return DateTime->new( year => $year, month => $month, day => $day);
}



#@Param - date in SQL form 
#@Returns - date in DateTime form
sub getDate()
{
	my $dateStr = shift;
	my $dt = DateTime::Format::MySQL->parse_datetime($dateStr); 
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


1;



