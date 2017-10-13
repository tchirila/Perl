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
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<link rel="stylesheet" href="stylesheet.css" />
			<title>Pensions</title>
			</head>
			<body>
				<header class="main-header">
					<div class="page-container">
						<h1>Pensions - login</h1>
					</div>
				</header>
			
				<div class="page container">
					<div class="col12">
						<form action="login.cgi" method="post">
							<div class="col12 breaker center-a">
								Employee Number<input type="text" name="employeeNumber" />	
							</div>
							<div class="col12 breaker center-a">
								Password <input	type="password" name="password">
							</div>
							<div class="col12 breaker center-a">
								<input class="center-a purchaseButton" type="submit" name="login" value="Login" />
							</div>
						</form>
					</div>
				</div>
				
				<footer class="row main-footer">
					<div class="col12">
						<a href=""> Return Home</a>
					</div>
				</footer>
			</body>
		</html>
	};	
}

main();
