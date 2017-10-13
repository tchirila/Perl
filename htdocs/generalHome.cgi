#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;

my $cgi = new CGI();

sub main()
{
	print $cgi->header();
	my $role = "General";
	
	print qq{
		<html>
			<h1>Pension Scheme: General</h1>
			<table>
				<tr><td><a href="employeeDetails.cgi?role=$role">View Your Details</a></td></tr>
				<tr><td><a href="contributions.cgi?role=$role">View Pension Contributions</a></td></tr>
				<tr><td><a href="charities.cgi?role=$role">Charities</a></td></tr>
			</table>
		</html>
		
		<html>
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<link rel="stylesheet" href="stylesheet.css" />
			<title>Pensions</title>
			</head>
			<body>
				<header class="main-header">
					<div class="page-container">
						<h1>Pensions - User Home</h1>
					</div>
				</header>
			
				<div class="page container">
					<div class="col12">
						<form action="login" method="post">
							<div class="col12 center-a">
								<a class="center-a" href="charities.cgi?role=$role">Charities</a>
							</div>
							<div class="col12 center-a">
								<a class="center-a" href="employeeDetails.cgi?role=$role">View Your Details</a>
							</div>
							<div class="col12 center-a">
								<a class="center-a" Shref="contributions.cgi?role=$role">View Pension Contributions</a>
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