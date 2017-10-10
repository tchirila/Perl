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


my @EXPORT_OK = qw(updateContributions);

$|=1;

our $MONTHLY_EMPLOYEE_CONTIBUTIONS = "E";
our $MONTHLY_EMPLOYER_CONTIBUTIONS = "C";
our $ANNUAL_EMPLOYER_CONTIBUTIONS = "A";



# single point of access for this class to update the system for
# a) monthly contributions for employee and employer
# b) annual contributions on anniversary of each employee
sub updateContributions()
{
	# find the last date the system was run from process history.process_date
	my $lastProcessDate;
	
	## TODO 1) get every employee on the system
	## TODO 2) for each employee, map the num v latest list of contributions	
	## TODO 3) supply this hash as a parameter to the other methods
	
	
	my $endOfMonthCount = generateEndOfMonthContributions();
	my $anniversCount = generateAnnualAnniversaryContributions();
	
	# add $endOfMonthCount + $anniversCount and create process history record in db
	# DAO::ConnectionDao.getAllProcessHistory() - the first record will be contain the last run date
}
  


# getAllContributionsForEmployeeId



# sub-routine for calculating annual employee anniversary contributions
# this subroutine should only be called from updateContributions()
# @param $lastProcessDate
# @param hash of all employees on the system employee id v latest contributions 
sub generateEndOfMonthContributions()
{
	# get a hash of all employees on the system: employee id v latest contributions
	my %contributions = shift;
	
	# init $count, to record how many contributions records are created in this process
	my $count = 0;
	
	# read param $lastProcessDate - the last time the system was run from process history.process_date
	
	
	
#	# for each employee
#	my @monthKeys = keys %months;  
#	foreach my $month(@monthKeys)  # LOOPING THROUGH HASH WITH KEYS
#	{
#		my $monthVal = $months{$month};
#		print "Month Value = $monthVal\n";
#	}
#	
	
	
	
	    # find the start date for this employee
	
		# determine the years for which annual contributions re due
		
		# ie:  either zero, 1, or > 1 (theoretically, if the system has been switched off for a while)    
		 		 
	# for each anniverary that is due an annual contribution 
		# get the salary from employee [because employee audit may not be implemented]
		# and get the annual employee amount 
		
	    # make the calculation creating a Contribution object
	    
	    # save the calculation to db 
	
	    # increment $count 
	
	# return $count
}





#print "\n\n";
#	my $employee1 = new Data::Employee(100, "Bobby", "51", now(), 10000, 3, 5, "A", "pass1", 1, now());
#	my $employee2 = new Data::Employee(101, "Bobby", "52", now(), 10000, 3, 5, "A", "pass1", 1, now());
#	my $employee3 = new Data::Employee(102, "Bobby", "53", now(), 10000, 3, 5, "A", "pass1", 1, now());
#	my $employee4 = new Data::Employee(103, "Bobby", "54", now(), 10000, 3, 5, "A", "pass1", 1, now());



#		print "\nempl num = $emplNum\n";
#		print "\nstart date XXXXXXXXXXXX = $emplStartDate\n";
#		print "\n\n";



# sub-routine for calculating end of month employee and employer contributions
# this subroutine should only be called from updateContributions()
# @param hash of employee id v latest contributions
sub generateAnnualAnniversaryContributions()
{
	# get hash of employee id v latest contributions
	#my %emplLastContributions = shift;
	
	# init $count, to record how many contributions records are created in this process
	my $count = 0;
	
	# loop through each employee on system
	my %employees = DAO::EmployeeDao::getAllEmployees();
	while(my ($key, $value) = each %employees){  # each functions contains an array of 2 values (ie $key, $value)
		my $emplNum = $key;
		my $employee = $value;
		my $emplId = $employee->{"id"};
		my $emplSalary = $employee->{"salary"};  
		my $emplAnnualEmployeeContr = $employee->{"eCont"};   # TODO  need to get this from a new field in DB table!!!   annContr 
		
		# find the start date for this employee
		my $emplStartDate = $employee->{"start_date"};
		
		# TODO get this data from a new DAO::ContributionDao method and set the array of contribution hashes for all employees once  
		my @contrForEmplee = getContributionsForEmployeeByType($MONTHLY_EMPLOYEE_CONTIBUTIONS, $emplId);
		my $lastContrDate = getLastDateContribution(@contrForEmplee);
		my @missingMonthlyDates = getMissingMonthlyContrDatesForEmployee($lastContrDate); 
		foreach my $date(@missingMonthlyDates)
		{
			# calculate the contribution value
			my $contrAmount = "";  #' $emplAnnualEmployeeContr
			
			# create a new contribution 
			
			
			my $employee = new Data::Contribution(-1, $ANNUAL_EMPLOYER_CONTIBUTIONS, $emplAnnualEmployeeContr, $contrAmount, $emplSalary,
			                             );
			
			# type,contr_pc,contr_amount,salary,process_date,effective_date,employees_id,charity_id
			
			
			$count++;
		}
		
		print "\n XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \n\n ";
		
		
		# apply basic logic.......not backwards
		#my $today = now();
		
		# if start date is today's date
		
		
		
	}
	
	return $count;
	
}



# Get the missing end of month dates for which there needs to be a monthly contribution added
#@param - $lastContrDate
sub getMissingMonthlyContrDatesForEmployee()
{
	
	
	# return dates in ascending order
}



# Returns the date of the most recent employee contributions 
#@param contributions - the contributions of 1 employee, (all of the same type)  
sub getLastDateContribution()
{
	
	
	
	
	return 0;
}




 
#@param type - contributions type (see definitions at top)
#@param employee id - $emplId
sub getContributionsForEmployeeByType()
{
	my $contrType = shift;
	my $emplId = shift;
	
	my @contribution = DAO::ContributionDao::getAllContributionsForEmployeeId($emplId); 
	
	#print "\n Employee = $emplNum   and  contr = " . scalar(@contribution) . "\n";
	
	# return the array of contributions
	return 1;
}






# 	my @latestContr = keys %emplLastContributions;
#	foreach my $contrType(@latestContr)
#	{
#		my $contr = $emplLastContributions{$contrType};
##		if ()
##		{
##			
##		}
#		
#		
#		
#		
#		
#		
#	}
 	
	

	
	
	
	
	# read param $lastProcessDate - the last time the system was run from process history.process_date
	
	# get a hash of all employees on the system
	
	# for each employee
	
	    
	
		# determine which end of months for which end of month contributions are due for this employee
		# maybe zero, 1 (or > 1 if the system has not been run for a while) 
		
			# for each of the end of months to be calculated for this employee
			
				# make the calculation and create a Contribution record
				
				# save the record
				
				# increment $count      

	# return $count	
}




