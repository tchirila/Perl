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
		my @missingAnnualEffDates = getMissingAnnualContrDatesForEmployeeInAscOrder($mostRecentAnnualContr, $emplStartDate);
		foreach my $effectiveDate(@missingAnnualEffDates)   
		{
			# create a new contribution record and persist it
			my $annContr = ($emplAnnualEmployeeContr / 100) * $emplSalary;   ## SUBROUTINE  !!!!
			my $annContrObj = new Data::Contribution(-1, $ANNUAL_EMPLOYER_CONTIBUTIONS, $emplAnnualEmployeeContr, $annContr, 
			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
			addContribution($annContrObj);
			$annualCount++;  
		}		
		
		
		# manage update of employee routines
		$mostRecentMnthEmplrContr
		
		


		my @missingMthEffDates = getMissingMnthContrDates($mostRecentMnthEmpleeContr);
#		foreach my $effectiveDate(@missingMthEffDates)  
#		{
#			# create and persist new employee contribution record
#			my $monthlyEmpleeContr = ($empleeContr / 100) * $emplSalary;    ## SUBROUTINE  !!!!
#			my $monthlyEmpleeContrObj = new Data::Contribution(-1, $MONTHLY_EMPLOYEE_CONTIBUTIONS, $empleeContr, $monthlyEmpleeContr, 
#			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
#			addContribution($monthlyEmpleeContrObj);
#			$mnthEmpleeCount++; 			                              
#			                              
#			# create and persist new employer contribution record                              
#			my $monthlyEmplerContr = ($emplerContr / 100) * $emplSalary;    ## SUBROUTINE  !!!!
#			my $monthlyEmplerContrObj = new Data::Contribution(-1, $MONTHLY_EMPLOYER_CONTIBUTIONS, $emplerContr, $monthlyEmplerContr, 
#			                              $emplSalary, $currSysTime, $effectiveDate, $emplId, $charityId);
#			addContribution($monthlyEmplerContrObj);
#			$mnthEmplerCount++; 
#		}
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
#@param - $mostRecentAnnualContr - the most recent annual contribution
#         note that this vaue may be undefined if it does not exist
#@param - employee start date                     
sub getMissingAnnualContrDatesForEmployeeInAscOrder()
{
	my $mostRecentAnnualContr = shift;  
	my $empleeStartDate = shift;
	unless(defined($mostRecentAnnualContr))
	{
		$mostRecentAnnualContr = $empleeStartDate;   # TODO does this need cloning?????
	}
	
	# define array of missing dates
	my @datesNoAnnualContr;
	
	# suggest the first possible date that may be due a contribution
	my $baseContrDate = getDate($mostRecentAnnualContr);
	my $possContrDate = incrementDateByYear();
	
	# get the time now in object form
	my $timeNow = DateTime->now;
		
	# while date < now>  
	my $allContrDatesRead = DateTime->compare($possContrDate, $timeNow);
	while ($allContrDatesRead <= 0)
	{
		# get datetime in string form and add to array
		my $possDateStr = getDateStr($possContrDate);
	    push @datesNoAnnualContr, $possDateStr;
		
	    # increment possContrDate by 1 year
		$possContrDate = incrementDateByYear();
		
		# determine if value of possContrDate is now in the past
		$allContrDatesRead = DateTime->compare($possContrDate, $timeNow);	
	}
	   
	return @datesNoAnnualContr;    	
}



# Get any anniversary dates for which there is no contribution record. 
# Return the list in ascending order
#@param - $lastContrDate
#@param - contributions type (see definitions at top)
sub getMissingMnthContrDates()
{
	
	
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



# Persists a contribution object
#@Param - Contribution object to be stored
sub addContribution() 
{
	my $contrObj = shift;
	if(defined($contrObj))
	{
		DAO::ContributionDao::addContribution($contrObj->{"type"}, $contrObj->{"cont_pc"}, $contrObj->{"cont_amount"}, $contrObj->{"salary"}, 
				$contrObj->{"effective_date"}, $contrObj->{"employees_id"}, $contrObj->{"charity_id"});
	}
}


sub incrementDateByYear()
{
	my $possContrDate = shift;
	my $year = $possContrDate->year;
	my $month = $possContrDate->month;
	my $day = $possContrDate->day;
	$possContrDate = DateTime->new( year => $year, month => $month, day => $day);
	return $possContrDate;
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


1;



