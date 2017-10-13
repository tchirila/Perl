#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;

my $cgi = new CGI();
my $role = $cgi->param('role');

sub main()
{
	print $cgi->header();
	my $homePage = "generalHome.cgi";
	
	if($role eq "HRAdmin"){
		$homePage = "adminHome.cgi"
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
						<h1>Pensions - Admin - View Contributions </h1>
					</div>
				</header>
				
				<div class="page-container">
					<form action="getEmployeeContributions" method="post">
						<div class="col6 breaker center-a">
							Employee <input name="employeenumber">		
						</div>
						<div class="col6 breaker center-a last">
							<input class="center-a purchaseButton" type="submit" value="Submit" />
						</div>
					</form>
						<div class="col2">
							Effective Date 
						</div>
						<div class="col2">
							Process Date
						</div>
						<div class="col1">
							Type 
						</div>
						<div class="col1">
							Salary
						</div>
						<div class="col2">
							Charity
						</div>
						<div class="col2">
							Contribution % 
						</div>
						<div class="col2 last">
							Amount
						</div>
					<!-- insert code to loop through passed results -->
					<!-- for-example a foreach loop starts here -->
						<div class="col2">
							<!-- insert (Effective Date value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Process Date value) passed to html page here -->
						</div>
						<div class="col1">
							<!-- insert (Type value) passed to html page here -->
						</div>
						<div class="col1">
							<!-- insert (Salary value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Charity value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Contribution %  value) passed to html page here -->
						</div>
						<div class="col2 last">
							<!-- insert (Amount  value) passed to html page here -->
						</div><!-- insert value passed to html page here -->
					<!-- and the foreach loop ends here --> 
					</div>
				
				<footer class="row main-footer">
					<div class="col12">
						<a href="$homePage">Home</a>
					</div>
				</footer>
			</body>
		</html>
	};	
}

main();