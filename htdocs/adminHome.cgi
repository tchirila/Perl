#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;

my $cgi = new CGI();

sub main()
{
	print $cgi->header();
	my $role = "HRAdmin";
	
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
						<h1>Pensions - Admin Home</h1>
					</div>
				</header>
			
				<div class="page container">
					<div class="col12">
						<form action="login" method="post">
							<div class="col12 center-a">
							<a href="charities.cgi?role=$role">Manage Charities</a>
							</div>
							<div class="col12 center-a">
								<a href="employeeDetails.cgi?role=$role">Manage Employee Details</a>
							</div>
							<div class="col12 center-a">
								<a href="contributions.cgi?role=$role">View Contributions for Employee</a>
							</div>
							<div class="col12 center-a">
								<a href="employeeHistory.cgi">Employee History</a>
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