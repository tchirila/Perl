package Data::Employee;
use Exporter qw(import);
use warnings;
use Data::Dumper;

@EXPORT_OK = qw(getName setName getNumber setNumber getDOB setDOB getSalary setSalary getEmployerContribution
	setEmployerContribution getEmployeeContribution setEmployeeContribution getEmployeeRole setEmployeeRole
	getEmployeePassword setEmployeePassword getCharityId setCharityId getStartDate setStartDate getAnnualContribution
	getAnnualContribution getId setId);

$|=1;

sub new {
	my $class = shift;
	my $employee = {
		"id" => shift,
		"name" => shift,
		"number" => shift,
		"DOB" => shift,
		"salary" => shift,
		"rCont" => shift,
		"eCont" => shift,
		"role" => shift,
		"pass" => shift,
 		"charity_id" => shift,
  		"start_date" => shift,
  		"annual_contr" => shift,
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
sub setEmployerContribution	{
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
sub setEmployeeContribution	{
	my $emp = shift;
	my $newCont = shift;
	$emp->{"eCont"} = $newCont;
}



#Param1: Employee object
sub getEmployeeRole	{
	return shift->{"role"};
}

#Param1: Employee object
#Param2: New role
sub setEmployeeRole	{
	my $emp = shift;
	my $newRole = shift;
	$emp->{"role"} = $newRole;
}



#Param1: Employee object
sub getEmployeePassword	{
	return shift->{"pass"};
}

#Param1: Employee object
#Param2: New password
sub setEmployeePassword	{
	my $emp = shift;
	my $newPass = shift;
	$emp->{"pass"} = $newPass;
}


#Param1: Employee object
sub getCharityId	{
	return shift->{"charity_id"};
}

#Param1: Employee object
#Param2: Charity ID
sub setCharityId	{
	my $emp = shift;
	my $id = shift;
	$emp->{"charity_id"} = $id;
}


#Param1: Employee object
sub getStartDate	{
	return shift->{"start_date"};
}

#Param1: Employee object
#Param2: New password
sub setStartDate	{
	my $emp = shift;
	my $date = shift;
	$emp->{"start_date"} = $date;
}


#Param1: Employee object
sub getAnnualContribution	{
	return shift->{"annual_contr"};
}

#Param1: Employee object
#Param2: Annual contribution
sub setAnnualContribution	{
	my $emp = shift;
	my $contr = shift;
	$emp->{"annual_contr"} = $contr;
}


#Param1: Employee object
sub getId	{
	return shift->{"id"};
}

#Param1: Employee object
#Param2: New ID
sub setId	{
	my $emp = shift;
	my $id = shift;
	$emp->{"id"} = $id;
}


1;