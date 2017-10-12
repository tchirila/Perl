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
						<h1>Pensions - Admin - Charities </h1>
					</div>
				</header>
				
				<div class="page-container">
					<form action="adminAddNewCharity" method="post">
						<div class="col12 breaker center-a">
							Name <input name="name">		
						</div>
						<div class="col12 breaker center-a">
							Address Line 1 <input name="addline1">
						</div>
						<div class="col12 breaker center-a">
							Address Line 2 <input name="addline2">
						</div>
						<div class="col12 breaker center-a">
							City <input name="city">
						</div>
						<div class="col12 breaker center-a">
							Postcode <input name="postcode">	
						</div>
						<div class="col12 breaker center-a">
							Country <input name="country">	
						</div>
						<div class="col12 breaker center-a">
							Telephone <input name="telephone">	
						</div>
						<div class="col12 breaker center-a">
							<input class="center-a purchaseButton" type="submit" value="Add" />
						</div>
					</form>
			
					<div class="col2">
							Name
						</div>
						<div class="col2">
							Address Line 1
						</div>
						<div class="col1">
							Line 2
						</div>
						<div class="col1">
							City
						</div>
						<div class="col1">
							Postcode
						</div>
						<div class="col2">
							Country
						</div>
						<div class="col2">
							Telephone
						</div>
						<div class="col1 last">
							Approved
						</div>
					<!-- insert code to loop through passed results -->
					<!-- for-example a foreach loop starts here -->
						<div class="col2">
							<!-- insert (Name value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Address Line 1 value) passed to html page here -->
						</div>
						<div class="col1">
							<!-- insert (Address Line 2 value) passed to html page here -->
						</div>
						<div class="col1">
							<!-- insert (City value) passed to html page here -->
						</div>
						<div class="col1">
							<!-- insert (Postcode value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Country  value) passed to html page here -->
						</div>
						<div class="col2">
							<!-- insert (Telephone  value) passed to html page here -->
						</div>
						<div class="col1 last">
							<!-- insert (Approved CHECKBOX) passed to html page here -->
						</div>
					<!-- and the foreach loop ends here --> 
			
					
				</div>
				
				<footer class="row main-footer">
					<div class="col12">
						<a href="$homePage">
					</div>
				</footer>
			</body>
		</html>
	};	
}

main();