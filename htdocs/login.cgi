#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;
use DAO::EmployeeDao;

my $cgi = new CGI();

sub main()
{	
	my %hash;
	my $role;
	my $name;
	
	if($cgi->param('login') && %hash == undef){
		my $employeeNumber = $cgi->param('employeeNumber');		
		%hash = DAO::EmployeeDao::getEmployee($employeeNumber);
		$role = %hash{"role"};
		$name = %hash{"name"};
	}
	
	if($role eq "A"){
		print $cgi->redirect("adminHome.cgi?name=$name");
	}
	elsif($role eq "G"){
		print $cgi->redirect("generalHome.cgi?name=$name");
	}
			
	print qq{
		<html>
			<form action="login.cgi" method="post">
				Employee Number<input type="text" name="employeeNumber" /><br>
				Password<input type="text"/><br>
				<input type="submit" name="login" value="Login"/><br> 
			</form>
		</html>
	};	
}

main();
