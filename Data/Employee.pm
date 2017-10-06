package Data::Employee;

use strict;
use warnings;
use Data::Dumper;

$|=1;

sub new {
	my $class = shift;
	my $name= shift; 
	my $number = shift;
	my $dob = shift;
	my $salary = shift;
	my $emprC = shift;
	my $empeC = shift;
	my $employee = {
		"name" => $name,
		"number" => $number,
		"DOB" => $dob,
		"salary" => $salary,
		"rCont" => $emprC,
		"eCont" => $empeC,
	};
	
	bless($employee, $class);

	return $employee;	
}

#Param1: Employee object
sub getName	{
	return shift->{"name"};
}

#Param1: Employee object
#Param2: New name
sub setName	{
	my $emp = shift;
	my $newName = shift;
	$emp->{"name"} = $newName;
}


#Param1: Employee object
sub getNumber	{
	return shift->{"number"};
}

#Param1: Employee object
#Param2: New number
sub setNumber	{
	my $emp = shift;
	my $newNum = shift;
	$emp->{"number"} = $newNum;
}


#Param1: Employee object
sub getDOB	{
	return shift->{"DOB"};
}

#Param1: Employee object
#Param2: New DOB
sub setDOB	{
	my $emp = shift;
	my $newDOB = shift;
	$emp->{"DOB"} = $newDOB;
}


#Param1: Employee object
sub getSalary	{
	return shift->{"salary"};
}

#Param1: Employee object
#Param2: New salary
sub setSalary	{
	my $emp = shift;
	my $newSalary = shift;
	$emp->{"salary"} = $newSalary;
}


#Param1: Employee object
sub getEmployerContribution	{
	return shift->{"rCont"};
}

#Param1: Employee object
#Param2: New contribution
sub setSEmployerContribution	{
	my $emp = shift;
	my $newCont = shift;
	$emp->{"rCont"} = $newCont;
}


#Param1: Employee object
sub getEmployeeContribution	{
	return shift->{"eCont"};
}

#Param1: Employee object
#Param2: New contribution
sub setSEmployeeContribution	{
	my $emp = shift;
	my $newCont = shift;
	$emp->{"eCont"} = $newCont;
}



1;