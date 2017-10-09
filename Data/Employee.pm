package Data::Employee;
use Exporter qw(import);
use warnings;
use Data::Dumper;

@EXPORT_OK = qw(getName setName getNumber setNumber getDOB setDOB getSalary setSalary getEmployerContribution
					setEmployerContribution getEmployeeContribution setEmployeeContribution);


$|=1;

sub new {
	my $class = shift;
	my $id = shift;
	my $name= shift;
	my $number = shift;
	my $dob = shift;
	my $salary = shift;
	my $emprC = shift;
	my $empeC = shift;
	my $role = shift;
	my $pass = shift;
	my $employee = {
		"name" => $name,
		"number" => $number,
		"DOB" => $dob,
		"salary" => $salary,
		"rCont" => $emprC,
		"eCont" => $empeC,
		"role" => $role,
		"pass" => $pass,
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


1;