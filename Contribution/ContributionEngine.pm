package Contribution::ContributionEngine;  
use strict;
use warnings;
use Data::Dumper;
use lib '..';
use Exporter qw(import);
require Data::Contribution;
require Data::Employee;
require Data::ProcessHistory;
require DAO::EmployeeDao;
require DAO::ConnectionDao;
require DAO::ContributionDao;
require DAO::ProcessHistoryDao;
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

	my $currSysTime = Utilities::Time::getCurrentTimestampTime();
	
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
sub updateSystemProcessRecords()
{
	my $currSysTime = shift; 
	my $currUserId = shift;
	my $annualCount = shift; 
	my $mnthEmpleeCount = shift; 
	my $mnthEmplerCount = shift;
	
	my $processTmp1 = new Data::ProcessHistory($currUserId, 1, $annualCount, $ANNUAL_EMPLOYER_CONTIBUTIONS);
	DAO::ProcessHistoryDao::addProcess($processTmp1);
	print "Successfully completed annual employee contribution update process on $currSysTime: $annualCount records persisted";

	my $processTmp2 = new Data::ProcessHistory($currUserId, 1, $mnthEmpleeCount, $MONTHLY_EMPLOYEE_CONTIBUTIONS);
	DAO::ProcessHistoryDao::addProcess($processTmp2);
	print "Successfully completed monthly employee contribution update process on $currSysTime: $mnthEmpleeCount records persisted";

	my $processTmp3 = new Data::ProcessHistory($currUserId, 1, $mnthEmplerCount, $MONTHLY_EMPLOYER_CONTIBUTIONS);
	DAO::ProcessHistoryDao::addProcess($processTmp3);
	print "Successfully completed monthly employer contribution update process on $currSysTime: $mnthEmplerCount records persisted";
}




# Get any array any dates up to today for which there is currently no contribution record. 
# Return the array in ascending order
#@param - $mostRecentContr - the string datetime of the most recent contribution effective date (if one exists)
#         note that this value may be undefined if it does not exist. 
#         [Format = 'YYYY-M-DD HH-MM-SS' NOTE: Time values are nil as this should be a date field]
#@param - employee start date [Format = 'YYYY-M-DD'] 
#@param - a number to describe if dealing with annual of monthly contributions (0 = annual, 1 == monthly)    
sub getMissingContrDatesForEmployeeInAscOrder()
{
	my $mostRecentContr = shift;  
	my $empleeStartDate = shift;
	my $incrementType = shift;
	
	# determine whether the most recent contribution at this stage is a date object (emloyee start date) 
	# or datetime (most recent existing contribution effective date)
	my $useDateFmt = 0;
	
	unless(defined($mostRecentContr))
	{
		$mostRecentContr = $empleeStartDate;
		$useDateFmt = 1;   
	}
	
	# define array of missing dates
	my @datesNoContr;
	
	# suggest the first possible date that may be due a contribution
	my $baseContrDate = createDateTimeObject($mostRecentContr, $useDateFmt);          
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


######################################################################




# Loads hash mapping each employee id with the latest date
#@param type - contributions type (see definitions at top)
#              Possible types:
               # $ANNUAL_EMPLOYER_CONTIBUTIONS
               # $MONTHLY_EMPLOYEE_CONTIBUTIONS
               # $MONTHLY_EMPLOYER_CONTIBUTIONS
# Returns - hash mapping each employee id with the latest date string for the given contributions type              
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
	
	# forward the input date by 1 month
	my $nextMnthDate = $date->add( months => 1, end_of_month => 'limit' );
	
	# forward to the end of next month 
	my $endNextMnthDate = getDateOnLastDayOfCurrentMonth($nextMnthDate);
	return $endNextMnthDate;
}



#@Param - the date string to be incremented to the last day of following month
#@Returns - the modified datetime object
sub getDateOnLastDayOfCurrentMonth()
{
	my $date = shift;
	my $endMnthDate = DateTime->last_day_of_month(  
	    year  =>  $date->year,
	    month => $date->month);
	return $endMnthDate;
}



# Converts a string date time into a specific datetime object (with default time values 00:00:00)
#@Param - the date object 
#@Param - the date format
sub createDateTimeObject()
{
	my $dateStr = shift;
	my $useDateFmt = shift;
	my $dateTime;
	if ($useDateFmt eq 1) # use date format
	{
		return DateTime::Format::MySQL->parse_date($dateStr);
	}
	else # use datetime format
	{
		return DateTime::Format::MySQL->parse_datetime($dateStr);   	
	}
}


#@Param - date in DateTime form
#@Returns - date in SQL form 
sub getDateStr()
{
	my $date = shift;
	my $dateStr = $date->ymd('-');   
	my $timeStr = $date->hms;   
	return $dateStr . " " . $timeStr; 
}


1;



