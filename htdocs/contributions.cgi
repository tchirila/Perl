#!D:/Program Files/Perl64/bin/perl.exe

use strict;
use warnings;
use CGI;
use DAO::ContributionDao;

my $cgi = new CGI();
my $role = $cgi->param('role');
my $employeeId = $cgi->param('id');

sub main()
{
	print $cgi->header();
	my $homePage = "generalHome.cgi";
	
	if($role eq "HRAdmin"){
		$homePage = "adminHome.cgi";
	}
	
	my @hashes = DAO::ContributionDao::getAllContributionsForEmployeeId($employeeId); # this line disrupts the page
	print buildHtml($homePage, @hashes);	
}

sub buildHtml
{
	my ($homePage, @hashes) = @_;

	my $start = qq{
		<hmtl>
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
	};
	
	my $content = $start;
	
	foreach my $hash(@hashes){
		my $effectiveDate = $hash->{"effective_date"};
		my $processDate = $hash->{"process_date"};
		my $type = $hash->{"type"};
		my $salary = $hash->{"salary"};
		my $charityId = $hash->{"charity_id"};
		my $contributionPc = $hash->{"contr_pc"};
		my $contributionAmount = $hash->{"contr_amount"};
		
		my $toLoop = qq{
						<div class="col2">		
							$effectiveDate	
						</div>
						<div class="col2">
							$processDate
						</div>
						<div class="col1">
							$type
						</div>
						<div class="col1">
							$salary
						</div>
						<div class="col2">
							$charityId
						</div>
						<div class="col2">
							$contributionPc
						</div>
						<div class="col2 last">
							$contributionAmount
						</div>
		};
		
		$content = $content . $toLoop;
	}
				
	my $end = qq{
				</div>
				<footer class="row main-footer">
					<div class="col12">
						<a href="$homePage">Home</a>
					</div>
				</footer>
			</body>
		</hmtl>
	};
	
	$content = $content . $end;
			
	return $content;
}

main();