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
			<h1>Pension Scheme: HRAdmin</h1>
			
			<table>
				<tr><td><a href="employeeDetails.cgi?role=$role">Manage Employee Details</a></td></tr>
				<tr><td><a href="contributions.cgi?role=$role">View Contributions for Employee</a></td></tr>
				<tr><td><a href="charities.cgi?role=$role">Manage Charities</a></td></tr>
				<tr><td><a href="employeeHistory.cgi">Employee History</a></td></tr>
			</table>
		</html>
	};	
}

main();