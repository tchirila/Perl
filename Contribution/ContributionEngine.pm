package Contribution::ContributionEngine;
use strict;
use warnings;
use Data::Dumper;
use lib '..';
use Exporter qw(import);
require Data::Employee;
require Data::Contribution;

my @EXPORT_OK = qw(updateContributions);

$|=1;


# single point of access for this class to update the system for
# a) monthly contributions for employee and employer
# b) annual contributions on anniversary of each employee
sub updateContributions()
{
	# find the last date the system was run from process history.process_date
	my $lastProcessDate;
	
	my $endOfMonthCount = generateEndOfMonthContributions();
	my $anniversCount = generateAnnualAnniversaryContributions();
	
	# add $endOfMonthCount + $anniversCount and create process history record in db 
}
  


# sub-routine for calculating annual employee anniversary contributions
# this subroutine should only be called from updateContributions()
# @param $lastProcessDate 
sub generateAnnualAnniversaryContributions()
{
	# init $count, to record how many contributions records are created in this process
	
	# read param $lastProcessDate - the last time the system was run from process history.process_date
	
	# get a hash of all employees on the system
	
	# for each employee
	
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



# sub-routine for calculating end of month employee and employer contributions
# this subroutine should only be called from updateContributions()
sub generateEndOfMonthContributions()
{
	# init $count, to record how many contributions records are created in this process
	
	# read param $lastProcessDate - the last time the system was run from process history.process_date
	
	# get a hash of all employees on the system
	
	# for each employee
	
	    # find the start date for this employee
	
		# determine which end of months for which end of month contributions are due for this employee
		# maybe zero, 1 (or > 1 if the system has not been run for a while) 
		
			# for each of the end of months to be calculated for this employee
			
				# make the calculation and create a Contribution record
				
				# save the record
				
				# increment $count      

	# return $count	
}




